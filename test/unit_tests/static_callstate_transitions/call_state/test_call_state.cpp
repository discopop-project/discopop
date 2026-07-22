#include <gtest/gtest.h>

#include "../../../../profiler/rtlib/static_callstate_transitions/CallState.hpp"

class CallStateTest : public ::testing::Test {};

TEST_F(CallStateTest, testGetId) {
  CallState state(42);
  EXPECT_EQ(state.get_id(), 42);
}

TEST_F(CallStateTest, testGetTransitionTargetWithoutRegisteredTransition) {
  CallState state(1);
  EXPECT_EQ(state.get_transition_target(99), nullptr);
}

TEST_F(CallStateTest, testRegisterAndGetTransitionTarget) {
  CallState source(1);
  CallState target(2);

  source.register_transition(10, &target);

  EXPECT_EQ(source.get_transition_target(10), &target);
  EXPECT_EQ(source.get_transition_target(11), nullptr);
}

TEST_F(CallStateTest, testRegisterTransitionOverwritesExistingTrigger) {
  CallState source(1);
  CallState target_a(2);
  CallState target_b(3);

  source.register_transition(10, &target_a);
  source.register_transition(10, &target_b);

  EXPECT_EQ(source.get_transition_target(10), &target_b);
}
