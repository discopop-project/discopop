#include <gtest/gtest.h>

#include "runtimeFunctionsGlobals.hpp"
#include "runtimeFunctionsTypes.hpp"
#include "runtimeFunctions.hpp"

using namespace dp;

class FirstAccessQueueTest : public ::testing::Test {
    // firstAccessQueue and secondAccessQueue live in ImmortalStorage and are left unconstructed
    // until the runtime starts up. Outside of an instrumented target nothing calls __dp_init, so
    // the fixture has to construct them itself before any test touches them.
    void SetUp() override {
        dp::ConstructImmortalGlobals();
    }

    void TearDown() override {
        dp::DestroyImmortalGlobals();
    }
};

// FirstAccessQueue::get registers a SecondAccessQueueElement in the given queue, owned by the caller
static void delete_elements(SecondAccessQueue &SAQ) {
    while (auto element = SAQ.Get()) {
        delete element;
    }
}

TEST_F(FirstAccessQueueTest, testConstructor) {
    auto FAQ = FirstAccessQueue(10);
}


// FAQ test get empty
TEST_F(FirstAccessQueueTest, testGetEmpty) {
    auto FAQ = FirstAccessQueue(10);
    ASSERT_TRUE(first_access_queue.empty());
    ASSERT_EQ(first_access_queue.Get(&second_access_queue), nullptr);
}

// FAQ test push
TEST_F(FirstAccessQueueTest, testPush) {
    auto FAQ = FirstAccessQueue(10);
    ASSERT_TRUE(FAQ.empty());
    auto FAQC_ptr = new FirstAccessQueueChunk(100);
    FAQ.Push(FAQC_ptr);
    ASSERT_FALSE(FAQ.empty());
    delete FAQC_ptr;
}

// FAQ test can_accept_entries
TEST_F(FirstAccessQueueTest, testCanAcceptEntries) {
    auto FAQ = FirstAccessQueue(3);
    auto SAQ = SecondAccessQueue(10);
    ASSERT_TRUE(FAQ.empty());
    auto FAQC_ptr_1 = new FirstAccessQueueChunk(100);
    auto FAQC_ptr_2 = new FirstAccessQueueChunk(100);
    auto FAQC_ptr_3 = new FirstAccessQueueChunk(100);

    ASSERT_TRUE(FAQ.CanAcceptEntries());
    FAQ.Push(FAQC_ptr_1);
    ASSERT_TRUE(FAQ.CanAcceptEntries());
    FAQ.Push(FAQC_ptr_2);
    ASSERT_TRUE(FAQ.CanAcceptEntries());
    FAQ.Push(FAQC_ptr_3);
    ASSERT_FALSE(FAQ.CanAcceptEntries());
    FAQ.Get(&SAQ);
    ASSERT_TRUE(FAQ.CanAcceptEntries());
    // FAQ.get registers a SecondAccessQueueElement per chunk; nobody consumes them here
    while (auto saqe = SAQ.Get()) {
        delete saqe;
    }

    delete_elements(SAQ);
    delete FAQC_ptr_1;
    delete FAQC_ptr_2;
    delete FAQC_ptr_3;
}

// FAQ test empty
TEST_F(FirstAccessQueueTest, testEmpty) {
    auto FAQ = FirstAccessQueue(3);
    auto SAQ = SecondAccessQueue(10);
    ASSERT_TRUE(FAQ.empty());
    auto FAQC_ptr_1 = new FirstAccessQueueChunk(100);
    auto FAQC_ptr_2 = new FirstAccessQueueChunk(100);
    auto FAQC_ptr_3 = new FirstAccessQueueChunk(100);


    FAQ.Push(FAQC_ptr_1);
    ASSERT_FALSE(FAQ.empty());
    FAQ.Push(FAQC_ptr_2);
    ASSERT_FALSE(FAQ.empty());
    FAQ.Push(FAQC_ptr_3);
    ASSERT_FALSE(FAQ.empty());

    FAQ.Get(&SAQ);
    ASSERT_FALSE(FAQ.empty());
    FAQ.Get(&SAQ);
    ASSERT_FALSE(FAQ.empty());
    FAQ.Get(&SAQ);
    ASSERT_TRUE(FAQ.empty());
    // FAQ.get registers a SecondAccessQueueElement per chunk; nobody consumes them here
    while (auto saqe = SAQ.Get()) {
        delete saqe;
    }

    delete_elements(SAQ);
    delete FAQC_ptr_1;
    delete FAQC_ptr_2;
    delete FAQC_ptr_3;

}

// FAQ test: set_max_size changes the limit checked by can_accept_entries, a limit of 0 is clamped to 1
TEST_F(FirstAccessQueueTest, testSetMaxSize) {
    auto FAQ = FirstAccessQueue(100);
    auto FAQC_ptr_1 = new FirstAccessQueueChunk(100);
    auto FAQC_ptr_2 = new FirstAccessQueueChunk(100);

    FAQ.SetMaxSize(0);
    ASSERT_TRUE(FAQ.CanAcceptEntries());
    FAQ.Push(FAQC_ptr_1);
    ASSERT_FALSE(FAQ.CanAcceptEntries());
    FAQ.SetMaxSize(2);
    ASSERT_TRUE(FAQ.CanAcceptEntries());
    FAQ.Push(FAQC_ptr_2);
    ASSERT_FALSE(FAQ.CanAcceptEntries());

    delete FAQC_ptr_1;
    delete FAQC_ptr_2;
}
