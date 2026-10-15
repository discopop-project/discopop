#include <gtest/gtest.h>

#include "runtimeFunctionsGlobals.hpp"
#include "runtimeFunctionsTypes.hpp"
#include "runtimeFunctions.hpp"
#include "memory/PerfectShadow.hpp"

using namespace dp;

class FirstAccessQueueChunkBufferTest : public ::testing::Test {};

// the buffer does not free the chunks it still holds when it is destroyed
static void delete_prepared_chunks(FirstAccessQueueChunkBuffer &FAQCB) {
    while (FAQCB.GetQueueSize() > 0) {
        delete FAQCB.GetPreparedChunk(10);
    }
}

// ctor
TEST_F(FirstAccessQueueChunkBufferTest, testConstructor) {
    auto FAQCB = FirstAccessQueueChunkBuffer(10);
}

// get queue size
TEST_F(FirstAccessQueueChunkBufferTest, testQueueSize) {
    auto FAQCB = FirstAccessQueueChunkBuffer(10);
    ASSERT_EQ(FAQCB.GetQueueSize(), 0);
    FAQCB.PrepareChunkIfRequired(10);
    ASSERT_EQ(FAQCB.GetQueueSize(), 1);
    delete_prepared_chunks(FAQCB);
}

// prepare if required empty
TEST_F(FirstAccessQueueChunkBufferTest, testPrepareEmpty) {
    auto FAQCB = FirstAccessQueueChunkBuffer(10);
    FAQCB.PrepareChunkIfRequired(10);
    ASSERT_EQ(FAQCB.GetQueueSize(), 1);
    delete_prepared_chunks(FAQCB);
}


// prepare if required yes
TEST_F(FirstAccessQueueChunkBufferTest, testPrepareRequiredYes) {
    auto FAQCB = FirstAccessQueueChunkBuffer(10);
    FAQCB.PrepareChunkIfRequired(10);
    FAQCB.PrepareChunkIfRequired(10);
    FAQCB.PrepareChunkIfRequired(10);
    ASSERT_EQ(FAQCB.GetQueueSize(), 3);
    FAQCB.PrepareChunkIfRequired(10);
    ASSERT_EQ(FAQCB.GetQueueSize(), 4);
    delete_prepared_chunks(FAQCB);
}

// prepare if required no
TEST_F(FirstAccessQueueChunkBufferTest, testPrepareRequiredNo) {
    auto FAQCB = FirstAccessQueueChunkBuffer(10);
    ASSERT_EQ(FAQCB.GetQueueSize(), 0);
    for(int i = 0; i < 10; ++i){
        FAQCB.PrepareChunkIfRequired(10);
    }
    ASSERT_EQ(FAQCB.GetQueueSize(), 10);
    FAQCB.PrepareChunkIfRequired(10);
    ASSERT_EQ(FAQCB.GetQueueSize(), 10);
    delete_prepared_chunks(FAQCB);
}

// get prepared chunk exists
TEST_F(FirstAccessQueueChunkBufferTest, testGetPreparedChunkExists) {
    auto FAQCB = FirstAccessQueueChunkBuffer(10);
    ASSERT_EQ(FAQCB.GetQueueSize(), 0);
    FAQCB.PrepareChunkIfRequired(10);
    FAQCB.PrepareChunkIfRequired(10);
    FAQCB.PrepareChunkIfRequired(10);
    ASSERT_EQ(FAQCB.GetQueueSize(), 3);

    auto faqc_ptr = FAQCB.GetPreparedChunk(10);
    ASSERT_EQ(FAQCB.GetQueueSize(), 2);
    ASSERT_EQ(faqc_ptr->GetElementCount(), 0);
    delete faqc_ptr;
    delete_prepared_chunks(FAQCB);
}

// get prepared chunk empty
TEST_F(FirstAccessQueueChunkBufferTest, testGetPreparedChunkDoesntExist) {
    auto FAQCB = FirstAccessQueueChunkBuffer(10);
    ASSERT_EQ(FAQCB.GetQueueSize(), 0);
    auto faqc_ptr = FAQCB.GetPreparedChunk(10);
    ASSERT_EQ(faqc_ptr->GetElementCount(), 0);
    ASSERT_EQ(FAQCB.GetQueueSize(), 0);

    FAQCB.PrepareChunkIfRequired(10);
    FAQCB.PrepareChunkIfRequired(10);
    ASSERT_EQ(FAQCB.GetQueueSize(), 2);

    delete faqc_ptr;
    delete_prepared_chunks(FAQCB);
}
