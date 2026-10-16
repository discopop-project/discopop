#include <gtest/gtest.h>

#include "runtimeFunctionsGlobals.hpp"
#include "runtimeFunctionsTypes.hpp"
#include "runtimeFunctions.hpp"
#include "memory/PerfectShadow.hpp"

using namespace dp;

class FirstAccessQueueChunkTest : public ::testing::Test {};

// ctor
TEST_F(FirstAccessQueueChunkTest, testConstructor) {
    auto FAQC = FirstAccessQueueChunk(10);
}

// is_full false empty
TEST_F(FirstAccessQueueChunkTest, testIsFullFalseEmpty) {
    auto FAQC = FirstAccessQueueChunk(10);
    ASSERT_FALSE(FAQC.IsFull());
}

// is_full false
TEST_F(FirstAccessQueueChunkTest, testIsFullFalse) {
    auto FAQC = FirstAccessQueueChunk(10);
    for(int i = 0; i < 5; ++i){
        FAQC.GetNextAccessInfoBuffer();
    }
    ASSERT_FALSE(FAQC.IsFull());
}

// is_full true
TEST_F(FirstAccessQueueChunkTest, testIsFullTrue) {
    auto FAQC = FirstAccessQueueChunk(10);
    for(int i = 0; i < 10; i++){
        auto& dummy = FAQC.GetNextAccessInfoBuffer();
    }
    ASSERT_TRUE(FAQC.IsFull());
}

// get_next_AccessInfo_buffer
TEST_F(FirstAccessQueueChunkTest, testGetNextAccessInfoBuffer) {
    auto FAQC = FirstAccessQueueChunk(10);
    while(!FAQC.IsFull()){
        AccessInfo& buffer = FAQC.GetNextAccessInfoBuffer();
        buffer.lid = 1337;
        buffer.aa_var = 142;
        buffer.addr = 42;
        buffer.skip = true;
    }
    ASSERT_EQ(FAQC.GetElementCount(), 10);

    // check stored values
    for(int i = 0; i < 10; ++i){
        ASSERT_EQ((*(FAQC.GetBuffer()))[i].lid, 1337);
        ASSERT_EQ((*(FAQC.GetBuffer()))[i].aa_var, 142);
        ASSERT_EQ((*(FAQC.GetBuffer()))[i].addr, 42);
        ASSERT_EQ((*(FAQC.GetBuffer()))[i].skip, true);
    }
}
