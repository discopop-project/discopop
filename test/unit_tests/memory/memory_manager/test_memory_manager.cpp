#include <gtest/gtest.h>

#include "../../../../rtlib/memory/MemoryManager.hpp"

#include <cstdint>
#include <vector>

// Tests for old version (i.e., capturing functionality)

class MemoryManagerTest : public ::testing::Test { };

TEST_F(MemoryManagerTest, testConstructor) {
    auto mm = __dp::MemoryManager{};

    ASSERT_EQ(mm.get_smallest_allocated_addr(), std::numeric_limits<ADDR>::max());
    ASSERT_EQ(mm.get_largest_allocated_addr(), std::numeric_limits<ADDR>::min());

    for (auto i = 1; i < 1024; i++) {
        ASSERT_EQ(mm.get_next_free_memory_region_id(), i);
    }

    ASSERT_EQ(mm.get_smallest_allocated_addr(), std::numeric_limits<ADDR>::max());
    ASSERT_EQ(mm.get_largest_allocated_addr(), std::numeric_limits<ADDR>::min());
}

TEST_F(MemoryManagerTest, testStack) {
    auto mm = __dp::MemoryManager{};

    mm.enter_new_function();
    mm.update_stack_addresses(0x1000, 0x2000);
    mm.enter_new_function();
    mm.update_stack_addresses(0x3000, 0x4000);
    mm.enter_new_function();
    mm.update_stack_addresses(0x5000, 0x6000);

    auto addr = mm.pop_last_stack_address();
    ASSERT_EQ(addr.first, 0x5000);
    ASSERT_EQ(addr.second, 0x6000);

    addr = mm.pop_last_stack_address();
    ASSERT_EQ(addr.first, 0x3000);
    ASSERT_EQ(addr.second, 0x4000);

    addr = mm.pop_last_stack_address();
    ASSERT_EQ(addr.first, 0x1000);
    ASSERT_EQ(addr.second, 0x2000);
}

TEST_F(MemoryManagerTest, testUpdateStackAddresses) {
    auto mm = __dp::MemoryManager{};

    mm.enter_new_function();
    mm.update_stack_addresses(0x2000, 0x3000);
    mm.update_stack_addresses(0x1000, 0x4000);

    auto addr = mm.pop_last_stack_address();
    ASSERT_EQ(addr.first, 0x1000);
    ASSERT_EQ(addr.second, 0x4000);
}

TEST_F(MemoryManagerTest, testIsStackAccess) {
    auto mm = __dp::MemoryManager{};

    mm.enter_new_function();

    ASSERT_FALSE(mm.is_stack_access(0x1000));
    ASSERT_FALSE(mm.is_stack_access(0x1500));
    ASSERT_FALSE(mm.is_stack_access(0x2000));
    ASSERT_FALSE(mm.is_stack_access(0x2500));
    ASSERT_FALSE(mm.is_stack_access(0x3000));
    ASSERT_FALSE(mm.is_stack_access(0x3500));
    ASSERT_FALSE(mm.is_stack_access(0x4000));
    ASSERT_FALSE(mm.is_stack_access(0x4500));
    ASSERT_FALSE(mm.is_stack_access(0x5000));
    ASSERT_FALSE(mm.is_stack_access(0x5500));
    ASSERT_FALSE(mm.is_stack_access(0x6000));
    ASSERT_FALSE(mm.is_stack_access(0x6500));

    mm.update_stack_addresses(0x1000, 0x2000);
    mm.enter_new_function();

    ASSERT_FALSE(mm.is_stack_access(0x1000));
    ASSERT_FALSE(mm.is_stack_access(0x1500));
    ASSERT_FALSE(mm.is_stack_access(0x2000));
    ASSERT_FALSE(mm.is_stack_access(0x2500));
    ASSERT_FALSE(mm.is_stack_access(0x3000));
    ASSERT_FALSE(mm.is_stack_access(0x3500));
    ASSERT_FALSE(mm.is_stack_access(0x4000));
    ASSERT_FALSE(mm.is_stack_access(0x4500));
    ASSERT_FALSE(mm.is_stack_access(0x5000));
    ASSERT_FALSE(mm.is_stack_access(0x5500));
    ASSERT_FALSE(mm.is_stack_access(0x6000));
    ASSERT_FALSE(mm.is_stack_access(0x6500));
    
    mm.update_stack_addresses(0x3000, 0x4000);
    mm.enter_new_function();

    ASSERT_FALSE(mm.is_stack_access(0x1000));
    ASSERT_FALSE(mm.is_stack_access(0x1500));
    ASSERT_FALSE(mm.is_stack_access(0x2000));
    ASSERT_FALSE(mm.is_stack_access(0x2500));
    ASSERT_FALSE(mm.is_stack_access(0x3000));
    ASSERT_FALSE(mm.is_stack_access(0x3500));
    ASSERT_FALSE(mm.is_stack_access(0x4000));
    ASSERT_FALSE(mm.is_stack_access(0x4500));
    ASSERT_FALSE(mm.is_stack_access(0x5000));
    ASSERT_FALSE(mm.is_stack_access(0x5500));
    ASSERT_FALSE(mm.is_stack_access(0x6000));
    ASSERT_FALSE(mm.is_stack_access(0x6500));
    
    mm.update_stack_addresses(0x5000, 0x6000);

    ASSERT_FALSE(mm.is_stack_access(0x1000));
    ASSERT_FALSE(mm.is_stack_access(0x1500));
    ASSERT_FALSE(mm.is_stack_access(0x2000));
    ASSERT_FALSE(mm.is_stack_access(0x2500));
    ASSERT_FALSE(mm.is_stack_access(0x3000));
    ASSERT_FALSE(mm.is_stack_access(0x3500));
    ASSERT_FALSE(mm.is_stack_access(0x4000));
    ASSERT_FALSE(mm.is_stack_access(0x4500));
    ASSERT_TRUE(mm.is_stack_access(0x5000));
    ASSERT_TRUE(mm.is_stack_access(0x5500));
    ASSERT_TRUE(mm.is_stack_access(0x6000));
    ASSERT_FALSE(mm.is_stack_access(0x6500));
    
    auto addr = mm.pop_last_stack_address();

    ASSERT_FALSE(mm.is_stack_access(0x1000));
    ASSERT_FALSE(mm.is_stack_access(0x1500));
    ASSERT_FALSE(mm.is_stack_access(0x2000));
    ASSERT_FALSE(mm.is_stack_access(0x2500));
    ASSERT_TRUE(mm.is_stack_access(0x3000));
    ASSERT_TRUE(mm.is_stack_access(0x3500));
    ASSERT_TRUE(mm.is_stack_access(0x4000));
    ASSERT_FALSE(mm.is_stack_access(0x4500));
    ASSERT_FALSE(mm.is_stack_access(0x5000));
    ASSERT_FALSE(mm.is_stack_access(0x5500));
    ASSERT_FALSE(mm.is_stack_access(0x6000));
    ASSERT_FALSE(mm.is_stack_access(0x6500));

    addr = mm.pop_last_stack_address();

    ASSERT_TRUE(mm.is_stack_access(0x1000));
    ASSERT_TRUE(mm.is_stack_access(0x1500));
    ASSERT_TRUE(mm.is_stack_access(0x2000));
    ASSERT_FALSE(mm.is_stack_access(0x2500));
    ASSERT_FALSE(mm.is_stack_access(0x3000));
    ASSERT_FALSE(mm.is_stack_access(0x3500));
    ASSERT_FALSE(mm.is_stack_access(0x4000));
    ASSERT_FALSE(mm.is_stack_access(0x4500));
    ASSERT_FALSE(mm.is_stack_access(0x5000));
    ASSERT_FALSE(mm.is_stack_access(0x5500));
    ASSERT_FALSE(mm.is_stack_access(0x6000));
    ASSERT_FALSE(mm.is_stack_access(0x6500));

    addr = mm.pop_last_stack_address();

    ASSERT_FALSE(mm.is_stack_access(0x1000));
    ASSERT_FALSE(mm.is_stack_access(0x1500));
    ASSERT_FALSE(mm.is_stack_access(0x2000));
    ASSERT_FALSE(mm.is_stack_access(0x2500));
    ASSERT_FALSE(mm.is_stack_access(0x3000));
    ASSERT_FALSE(mm.is_stack_access(0x3500));
    ASSERT_FALSE(mm.is_stack_access(0x4000));
    ASSERT_FALSE(mm.is_stack_access(0x4500));
    ASSERT_FALSE(mm.is_stack_access(0x5000));
    ASSERT_FALSE(mm.is_stack_access(0x5500));
    ASSERT_FALSE(mm.is_stack_access(0x6000));
    ASSERT_FALSE(mm.is_stack_access(0x6500));
}
