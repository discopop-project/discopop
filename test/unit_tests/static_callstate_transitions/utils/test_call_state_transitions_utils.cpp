#include <gtest/gtest.h>

#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <memory>
#include <string>
#include <thread>

#include "runtimeFunctionsGlobals.hpp"
#include "static_callstate_transitions/utils.hpp"

// The callpath state tracking (static_callstate_transitions/utils.hpp) operates on the global
// dp::current_callpath_state and dp::call_state_graph. Each test builds a small, deterministic
// state graph and installs it into those globals before running:
//
//   state 1: main (function entry id 100, root entry state of main)
//     --10--> 2 (call instruction node) --0--> 3: callee (function entry id 200)
//     --30--> 4: main_loopstate0 --31--> 5: main_loopstate1
//   state 3 --40--> 6: callee_loopstate0
//   state 7: root entry state of function 300 (no caller in its translation unit)
//   state 1 --50--> 8 (call instruction node of a call into a function without instrumentation,
//     "library") --0--> 9: function node without entry id
//
// Constructing the graph from a directory without profiler output reports the missing input
// files on stderr; that output is expected here.
class CallStateTransitionsUtilsTest : public ::testing::Test {
protected:
  std::unique_ptr<CallStateGraph> graph;

  void SetUp() override {
    setenv("DOT_DISCOPOP_PROFILER", "/tmp/discopop_ut_nonexistent_dir", 1);

    graph = std::make_unique<CallStateGraph>();
    graph->RegisterFunctionEntryState(100, 1);
    graph->RegisterTransition(1, 10, 2);
    graph->RegisterTransition(2, 0, 3);
    graph->RegisterStateFunction(3, 200);
    graph->RegisterTransition(1, 30, 4);
    graph->RegisterTransition(4, 31, 5);
    graph->RegisterTransition(3, 40, 6);
    graph->RegisterFunctionEntryState(300, 7);
    graph->RegisterTransition(1, 50, 8);
    graph->RegisterTransition(8, 0, 9);

    dp::call_state_graph = graph.get();
    dp::ResetCallstateTracking(graph->GetOrRegisterNode(1));
  }

  void TearDown() override {
    dp::ResetCallstateTracking(nullptr);
    dp::call_state_graph = nullptr;
  }

  int32_t state() { return dp::current_callpath_state->GetId(); }
};

TEST_F(CallStateTransitionsUtilsTest, testUpdateCallstateFollowsExistingTransition) {
  dp::UpdateCallstate(30);
  EXPECT_EQ(state(), 4);
}

TEST_F(CallStateTransitionsUtilsTest, testUpdateCallstateIgnoresUnknownTrigger) {
  dp::UpdateCallstate(999);
  EXPECT_EQ(state(), 1);
}

TEST_F(CallStateTransitionsUtilsTest, testCallAloneDoesNotChangeTheState) {
  dp::RegisterCallForCallstate(10);
  EXPECT_EQ(state(), 1);
  EXPECT_EQ(dp::CallstateFrameCount(), 0u);
}

TEST_F(CallStateTransitionsUtilsTest, testEnteringTheCalledFunctionFollowsTheCallAndTheFallthrough) {
  dp::RegisterCallForCallstate(10);
  dp::EnterFunctionForCallstate(200);
  EXPECT_EQ(state(), 3);
  EXPECT_FALSE(dp::CallstateTransitionsFrozen());
  EXPECT_EQ(dp::CallstateFrameCount(), 1u);
}

TEST_F(CallStateTransitionsUtilsTest, testLeavingAFunctionRestoresTheCallersState) {
  dp::UpdateCallstate(30);
  dp::UpdateCallstate(31);
  dp::RegisterCallForCallstate(10);
  // the call leaves from main_loopstate1, which has no transition for it: the callee's own root
  // entry state does not exist either, so the state is frozen
  dp::EnterFunctionForCallstate(200);
  dp::UpdateCallstate(40);
  dp::LeaveFunctionForCallstate();
  EXPECT_EQ(state(), 5);
  EXPECT_FALSE(dp::CallstateTransitionsFrozen());
  EXPECT_EQ(dp::CallstateFrameCount(), 0u);
}

TEST_F(CallStateTransitionsUtilsTest, testLoopTransitionsInsideTheCalleeAreUndoneOnReturn) {
  dp::RegisterCallForCallstate(10);
  dp::EnterFunctionForCallstate(200);
  dp::UpdateCallstate(40);
  EXPECT_EQ(state(), 6);
  // a return from inside the loop, without its loop exit
  dp::LeaveFunctionForCallstate();
  EXPECT_EQ(state(), 1);
}

// P3: a call into code without instrumentation (e.g. an indirect call of a library function)
// never enters an instrumented function, so it must neither change nor freeze the state
TEST_F(CallStateTransitionsUtilsTest, testCallIntoUninstrumentedCodeKeepsTransitionsEnabled) {
  dp::RegisterCallForCallstate(77); // indirect call, no static transition
  // the callee returns without __dp_func_entry / __dp_func_exit
  dp::UpdateCallstate(30);
  EXPECT_EQ(state(), 4);
  EXPECT_FALSE(dp::CallstateTransitionsFrozen());
  // a later call still enters its callee's state
  dp::UpdateCallstate(31);
  dp::RegisterCallForCallstate(999);
  dp::LeaveFunctionForCallstate(); // no frame: ignored
  EXPECT_EQ(state(), 5);
}

TEST_F(CallStateTransitionsUtilsTest, testUninstrumentedCalleeCallingBackDoesNotUseTheCallsTransition) {
  // main calls a library function (call 50 -> state 9 without entry id), which calls back into the
  // instrumented function 200: the transition of call 50 does not lead into function 200
  dp::RegisterCallForCallstate(50);
  dp::EnterFunctionForCallstate(200);
  EXPECT_NE(state(), 9);
  EXPECT_EQ(state(), 1);
  EXPECT_TRUE(dp::CallstateTransitionsFrozen());
  dp::LeaveFunctionForCallstate();
  EXPECT_FALSE(dp::CallstateTransitionsFrozen());
}

// P2: a function entered without a matching call transition (call from another translation unit,
// constructor alias, virtual call) switches to its root entry state
TEST_F(CallStateTransitionsUtilsTest, testEnteringWithoutTransitionSwitchesToTheRootEntryState) {
  dp::UpdateCallstate(30);
  dp::RegisterCallForCallstate(77);
  dp::EnterFunctionForCallstate(300);
  EXPECT_EQ(state(), 7);
  EXPECT_FALSE(dp::CallstateTransitionsFrozen());
  dp::LeaveFunctionForCallstate();
  EXPECT_EQ(state(), 4);
}

TEST_F(CallStateTransitionsUtilsTest, testFunctionEnteredWithoutCallSwitchesToTheRootEntryState) {
  // e.g. called by library code, without a preceding __dp_call
  dp::EnterFunctionForCallstate(300);
  EXPECT_EQ(state(), 7);
}

TEST_F(CallStateTransitionsUtilsTest, testFrozenStateDisablesLoopAndCallTransitions) {
  dp::RegisterCallForCallstate(77);
  dp::EnterFunctionForCallstate(555); // unknown function: frozen in main's state
  EXPECT_TRUE(dp::CallstateTransitionsFrozen());
  dp::UpdateCallstate(30); // main's loop id must not move the state while in the unknown function
  EXPECT_EQ(state(), 1);
  dp::RegisterCallForCallstate(10);
  dp::EnterFunctionForCallstate(200); // relative transitions are disabled while frozen
  EXPECT_EQ(state(), 1);
  dp::LeaveFunctionForCallstate();
  // root entry states remain reachable while frozen
  dp::EnterFunctionForCallstate(300);
  EXPECT_EQ(state(), 7);
  dp::LeaveFunctionForCallstate();
  dp::LeaveFunctionForCallstate();
  EXPECT_FALSE(dp::CallstateTransitionsFrozen());
  EXPECT_EQ(state(), 1);
  dp::UpdateCallstate(30);
  EXPECT_EQ(state(), 4);
}

TEST_F(CallStateTransitionsUtilsTest, testPendingCallIsConsumedByTheFirstEntry) {
  dp::RegisterCallForCallstate(10);
  dp::EnterFunctionForCallstate(200);
  dp::LeaveFunctionForCallstate();
  // no new call: a second entry (e.g. a callback) does not reuse call 10
  dp::EnterFunctionForCallstate(200);
  EXPECT_EQ(state(), 1);
  EXPECT_TRUE(dp::CallstateTransitionsFrozen());
}

TEST_F(CallStateTransitionsUtilsTest, testRecursionThroughTheRootEntryState) {
  dp::EnterFunctionForCallstate(100); // main
  EXPECT_EQ(state(), 1);
  dp::RegisterCallForCallstate(10);
  dp::EnterFunctionForCallstate(200);
  dp::EnterFunctionForCallstate(300);
  dp::EnterFunctionForCallstate(300);
  EXPECT_EQ(dp::CallstateFrameCount(), 4u);
  dp::LeaveFunctionForCallstate();
  dp::LeaveFunctionForCallstate();
  EXPECT_EQ(state(), 3);
  dp::LeaveFunctionForCallstate();
  dp::LeaveFunctionForCallstate();
  EXPECT_EQ(state(), 1);
}

TEST_F(CallStateTransitionsUtilsTest, testOtherThreadsDoNotChangeTheState) {
  std::thread other([]() {
    dp::RegisterCallForCallstate(10);
    dp::EnterFunctionForCallstate(300);
    dp::UpdateCallstate(30);
    dp::LeaveFunctionForCallstate();
  });
  other.join();
  EXPECT_EQ(state(), 1);
  EXPECT_EQ(dp::CallstateFrameCount(), 0u);
}

TEST_F(CallStateTransitionsUtilsTest, testPendingCallIsPerThread) {
  dp::RegisterCallForCallstate(10);
  std::thread other([]() { dp::RegisterCallForCallstate(50); });
  other.join();
  dp::EnterFunctionForCallstate(200);
  EXPECT_EQ(state(), 3);
}

// an exception thrown in function 300 (entered from callee 200) is caught in main (100): the exits
// of 300 and 200 never run, the landing pad of main restores main's state at its call
TEST_F(CallStateTransitionsUtilsTest, testLandingPadDiscardsTheStatesOfUnwoundFunctions) {
  dp::EnterFunctionForCallstate(100);
  dp::UpdateCallstate(30);
  EXPECT_EQ(state(), 4);
  dp::RegisterCallForCallstate(10);
  dp::EnterFunctionForCallstate(200); // frozen: no transition from state 4
  dp::EnterFunctionForCallstate(300);
  EXPECT_EQ(state(), 7);
  dp::ResumeFunctionForCallstate(100);
  EXPECT_EQ(state(), 4);
  EXPECT_FALSE(dp::CallstateTransitionsFrozen());
  EXPECT_EQ(dp::CallstateFrameCount(), 1u);
  dp::UpdateCallstate(31);
  EXPECT_EQ(state(), 5);
}

TEST_F(CallStateTransitionsUtilsTest, testLandingPadOfTheCurrentFunctionKeepsTheState) {
  dp::EnterFunctionForCallstate(100);
  dp::RegisterCallForCallstate(10);
  dp::EnterFunctionForCallstate(200);
  dp::UpdateCallstate(40);
  // a cleanup landing pad in function 200 itself (e.g. a destructor call while unwinding)
  dp::ResumeFunctionForCallstate(200);
  EXPECT_EQ(state(), 6);
  EXPECT_EQ(dp::CallstateFrameCount(), 2u);
}

TEST_F(CallStateTransitionsUtilsTest, testLandingPadOfAnUnknownFunctionChangesNothing) {
  dp::EnterFunctionForCallstate(300);
  dp::ResumeFunctionForCallstate(555);
  EXPECT_EQ(state(), 7);
  EXPECT_EQ(dp::CallstateFrameCount(), 1u);
}

// A transition triggered by instruction id 0 is a fall-through: reaching a state that has one means
// passing straight through it. Both a loop transition and a call resolve it, so neither ever reports
// the intermediate state.
TEST_F(CallStateTransitionsUtilsTest, testAFallThroughTransitionIsTakenImmediately) {
  graph->RegisterTransition(2, 0, 4);

  dp::UpdateCallstate(10);

  EXPECT_EQ(dp::current_callpath_state->GetId(), 4);
}

TEST_F(CallStateTransitionsUtilsTest, testACallTakesTheFallThroughAsWell) {
  // call instruction 10 leads to the call instruction node 2, whose fall-through enters the callee
  dp::RegisterCallForCallstate(10);
  dp::EnterFunctionForCallstate(200);

  EXPECT_EQ(dp::current_callpath_state->GetId(), 3);
  EXPECT_EQ(dp::CallstateFrameCount(), 1u);
}

// only one fall-through is resolved per step, not a chain of them
TEST_F(CallStateTransitionsUtilsTest, testOnlyOneFallThroughIsResolvedPerStep) {
  graph->RegisterTransition(2, 0, 4);
  graph->RegisterTransition(4, 0, 5);

  dp::UpdateCallstate(10);

  EXPECT_EQ(dp::current_callpath_state->GetId(), 4);
}

// entering a function whose state is unknown disables transitioning until it is left, and
// update_callstate respects that just as the call-related functions do
TEST_F(CallStateTransitionsUtilsTest, testUpdateCallstateDoesNothingWhileDisabled) {
  dp::RegisterCallForCallstate(999);
  dp::EnterFunctionForCallstate(555);
  ASSERT_TRUE(dp::CallstateTransitionsFrozen());

  dp::UpdateCallstate(10);

  EXPECT_EQ(dp::current_callpath_state->GetId(), 1);
}

// leaving a function restores the state of its caller, whichever state the callee ended in
TEST_F(CallStateTransitionsUtilsTest, testLeavingTheCalleeRestoresTheStateOfTheCall) {
  dp::RegisterCallForCallstate(10);
  dp::EnterFunctionForCallstate(200);
  dp::UpdateCallstate(40);
  ASSERT_EQ(dp::current_callpath_state->GetId(), 6);

  dp::LeaveFunctionForCallstate();

  EXPECT_EQ(dp::current_callpath_state->GetId(), 1);
  EXPECT_EQ(dp::CallstateFrameCount(), 0u);
}

// initialize_current_callpath_state() reads the state the program starts in from
// "initial_stateID.txt" and establishes the base entry of the call depth stack.
class InitializeCurrentCallpathStateTest : public ::testing::Test {
protected:
  std::filesystem::path directory;
  std::unique_ptr<CallStateGraph> graph;

  void SetUp() override {
    directory = std::filesystem::temp_directory_path() / "discopop_ut_initial_state";
    std::filesystem::remove_all(directory);
    std::filesystem::create_directories(directory);
    setenv("DOT_DISCOPOP_PROFILER", directory.c_str(), 1);

    graph = std::make_unique<CallStateGraph>();
    dp::call_state_graph = graph.get();
    dp::ResetCallstateTracking(nullptr);
  }

  void TearDown() override {
    dp::call_state_graph = nullptr;
    dp::ResetCallstateTracking(nullptr);
    std::filesystem::remove_all(directory);
  }

  void write_initial_state(const std::string &content) const {
    std::ofstream file(directory / "initial_stateID.txt");
    file << content;
  }
};

TEST_F(InitializeCurrentCallpathStateTest, testTheStateFromTheFileBecomesTheCurrentOne) {
  write_initial_state("7\n");

  dp::InitializeCurrentCallpathState();

  ASSERT_NE(dp::current_callpath_state, nullptr);
  EXPECT_EQ(dp::current_callpath_state->GetId(), 7);
  EXPECT_EQ(dp::current_callpath_state, dp::call_state_graph->GetOrRegisterNode(7));
}

// the tracking starts outside of any entered function, with transitions enabled
TEST_F(InitializeCurrentCallpathStateTest, testTheTrackingStartsWithoutFramesAndEnabled) {
  write_initial_state("7\n");

  dp::InitializeCurrentCallpathState();

  EXPECT_EQ(dp::CallstateFrameCount(), 0u);
  EXPECT_FALSE(dp::CallstateTransitionsFrozen());
}

// the pass appends to the file instead of replacing it, so a rebuilt target leaves several ids
// behind and the one written last is the one that counts
TEST_F(InitializeCurrentCallpathStateTest, testTheLastIdInTheFileWins) {
  write_initial_state("3\n7\n");

  dp::InitializeCurrentCallpathState();

  ASSERT_NE(dp::current_callpath_state, nullptr);
  EXPECT_EQ(dp::current_callpath_state->GetId(), 7);
}

// A missing or empty file is the normal outcome for a target whose call path tree holds no "main",
// because the pass writes the id only when it finds one. The id used to be read uninitialized in
// that case -- g++ -Wmaybe-uninitialized points straight at it. The fallback reports itself on
// stderr; that output is expected here.
TEST_F(InitializeCurrentCallpathStateTest, testAMissingFileLeavesTheInitialStateDefined) {
  dp::InitializeCurrentCallpathState();

  ASSERT_NE(dp::current_callpath_state, nullptr);
  EXPECT_EQ(dp::current_callpath_state->GetId(), 0);
  EXPECT_EQ(dp::CallstateFrameCount(), 0u);
  EXPECT_FALSE(dp::CallstateTransitionsFrozen());
}

TEST_F(InitializeCurrentCallpathStateTest, testAnEmptyFileLeavesTheInitialStateDefined) {
  write_initial_state("");

  dp::InitializeCurrentCallpathState();

  ASSERT_NE(dp::current_callpath_state, nullptr);
  EXPECT_EQ(dp::current_callpath_state->GetId(), 0);
}

// a state without transitions is a state the call path never leaves
TEST_F(InitializeCurrentCallpathStateTest, testTheFallbackStateSimplyDoesNotMove) {
  dp::InitializeCurrentCallpathState();

  dp::UpdateCallstate(10);

  ASSERT_NE(dp::current_callpath_state, nullptr);
  EXPECT_EQ(dp::current_callpath_state->GetId(), 0);
}

// unwind_function_stack() calls __dp_func_exit until the function stack level has passed zero, so a
// target can leave more functions than it entered. Leaving without a frame keeps the state.
TEST_F(CallStateTransitionsUtilsTest, testLeavingMoreFunctionsThanWereEnteredKeepsTheState) {
  dp::LeaveFunctionForCallstate();
  dp::LeaveFunctionForCallstate();

  EXPECT_EQ(dp::current_callpath_state->GetId(), 1);
  EXPECT_EQ(dp::CallstateFrameCount(), 0u);

  dp::UpdateCallstate(30);
  EXPECT_EQ(dp::current_callpath_state->GetId(), 4);
}

// the same for the initial state: a line that is not a number is skipped, not thrown over
TEST_F(InitializeCurrentCallpathStateTest, testALineThatIsNotANumberIsSkipped) {
  write_initial_state("not a state id\n7\n");

  ASSERT_NO_THROW(dp::InitializeCurrentCallpathState());

  ASSERT_NE(dp::current_callpath_state, nullptr);
  EXPECT_EQ(dp::current_callpath_state->GetId(), 7);
}

TEST_F(InitializeCurrentCallpathStateTest, testAFileWithNothingUsableFallsBackToTheDefinedState) {
  write_initial_state("not a state id\n");

  ASSERT_NO_THROW(dp::InitializeCurrentCallpathState());

  ASSERT_NE(dp::current_callpath_state, nullptr);
  EXPECT_EQ(dp::current_callpath_state->GetId(), 0);
}
