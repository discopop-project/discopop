#include <gtest/gtest.h>

#include "../../../../rtlib/memory/MemoryRegionTree.hpp"

#include <cstdint>
#include <vector>

// Tests for old version (i.e., capturing functionality)

class MRTNodeTest : public ::testing::Test { };

TEST_F(MRTNodeTest, testGetCharAtLevel) {
    const auto levels = std::vector{0ULL, 1ULL, 2ULL, 3ULL, 4ULL, 5ULL, 6ULL, 7ULL, 8ULL, 9ULL, 10ULL, 11ULL, 12ULL, 13ULL, 14ULL, 15ULL};
    const auto addrs = std::vector{0x0000000000000000ULL, 0x1111111111111111ULL, 0x2222222222222222ULL, 0x3333333333333333ULL, 0x4444444444444444ULL, 0x5555555555555555ULL, 0x6666666666666666ULL, 0x7777777777777777ULL, 0x8888888888888888ULL, 0x9999999999999999ULL, 0xAAAAAAAAAAAAAAAAULL, 0xBBBBBBBBBBBBBBBBULL, 0xCCCCCCCCCCCCCCCCULL, 0xDDDDDDDDDDDDDDDDULL, 0xEEEEEEEEEEEEEEEEULL, 0xFFFFFFFFFFFFFFFFULL};

    for (auto i = 0; i < 16; i++) {
        for (const auto level : levels) {
            ASSERT_EQ(i, get_char_at_level(addrs[i], level));
        }
    }
}

TEST_F(MRTNodeTest, testGetLevelShiftingMask) {
    ASSERT_EQ(get_level_shifting_mask(0), 0xF000000000000000ULL);
    ASSERT_EQ(get_level_shifting_mask(1), 0x0F00000000000000ULL);
    ASSERT_EQ(get_level_shifting_mask(2), 0x00F0000000000000ULL);
    ASSERT_EQ(get_level_shifting_mask(3), 0x000F000000000000ULL);
    ASSERT_EQ(get_level_shifting_mask(4), 0x0000F00000000000ULL);
    ASSERT_EQ(get_level_shifting_mask(5), 0x00000F0000000000ULL);
    ASSERT_EQ(get_level_shifting_mask(6), 0x000000F000000000ULL);
    ASSERT_EQ(get_level_shifting_mask(7), 0x0000000F00000000ULL);
    ASSERT_EQ(get_level_shifting_mask(8), 0x00000000F0000000ULL);
    ASSERT_EQ(get_level_shifting_mask(9), 0x000000000F000000ULL);
    ASSERT_EQ(get_level_shifting_mask(10), 0x0000000000F00000ULL);
    ASSERT_EQ(get_level_shifting_mask(11), 0x00000000000F0000ULL);
    ASSERT_EQ(get_level_shifting_mask(12), 0x000000000000F000ULL);
    ASSERT_EQ(get_level_shifting_mask(13), 0x0000000000000F00ULL);
    ASSERT_EQ(get_level_shifting_mask(14), 0x00000000000000F0ULL);
    ASSERT_EQ(get_level_shifting_mask(15), 0x000000000000000FULL);

    for (auto i = 16; i < 1024; i++) {
        ASSERT_EQ(get_level_shifting_mask(i), 0xFFFFFFFFFFFFFFFFULL);
    }
}

TEST_F(MRTNodeTest, testGetShift) {
    ASSERT_EQ(get_shift(0), 60);
    ASSERT_EQ(get_shift(1), 56);
    ASSERT_EQ(get_shift(2), 52);
    ASSERT_EQ(get_shift(3), 48);
    ASSERT_EQ(get_shift(4), 44);
    ASSERT_EQ(get_shift(5), 40);
    ASSERT_EQ(get_shift(6), 36);
    ASSERT_EQ(get_shift(7), 32);
    ASSERT_EQ(get_shift(8), 28);
    ASSERT_EQ(get_shift(9), 24);
    ASSERT_EQ(get_shift(10), 20);
    ASSERT_EQ(get_shift(11), 16);
    ASSERT_EQ(get_shift(12), 12);
    ASSERT_EQ(get_shift(13), 8);
    ASSERT_EQ(get_shift(14), 4);
    ASSERT_EQ(get_shift(15), 0);

    for (auto i = 16; i < 1024; i++) {
        ASSERT_EQ(get_shift(i), -1);
    }
}

TEST_F(MRTNodeTest, testConstructor1) {
    const auto addr = 0x1234567890ABCDEFULL;
    const auto level = 0x1234;
    
    const auto node = MRTNode(addr, level);

    ASSERT_EQ(node.addr, addr);
    ASSERT_EQ(node.level, level);
    ASSERT_EQ(node.parent, nullptr);
    ASSERT_EQ(node.memoryRegionId, 0);
    
    for (auto i = 0; i < 16; i++) {
        ASSERT_EQ(node.children[i], nullptr);
    }
}

TEST_F(MRTNodeTest, testConstructor2) {
    const auto addr = 0x1234567890ABCDEFULL;
    const auto level = 0x1234;
    auto parent = MRTNode(0xFEDCBA9873210ULL, 0x4321);

    const auto node = MRTNode(&parent, addr, level);

    ASSERT_EQ(node.addr, addr);
    ASSERT_EQ(node.level, level);
    ASSERT_EQ(node.parent, &parent);
    ASSERT_EQ(node.memoryRegionId, 0);
    
    for (auto i = 0; i < 16; i++) {
        ASSERT_EQ(node.children[i], nullptr);
    }
}

TEST_F(MRTNodeTest, testConstructor3) {
    const auto addr = 0x1234567890ABCDEFULL;
    const auto level = 0x1234;
    auto parent = MRTNode(0xFEDCBA9873210ULL, 0x4321);
    const auto memoryRegionId = 0x5678;

    const auto node = MRTNode(&parent, addr, memoryRegionId, level);

    ASSERT_EQ(node.addr, addr);
    ASSERT_EQ(node.level, level);
    ASSERT_EQ(node.parent, &parent);
    ASSERT_EQ(node.memoryRegionId, memoryRegionId);
    
    for (auto i = 0; i < 16; i++) {
        ASSERT_EQ(node.children[i], nullptr);
    }
}

class MRTNodeTest2 : public ::testing::Test { };

TEST_F(MRTNodeTest2, testConstructor) {
    const auto start_addr = 0x1234567890ABCDEFLL;
    const auto end_addr = 0x2234567890ABCDEFLL;
    const auto level = 0x1234;
    
    const auto node = MRTNode2(start_addr, end_addr, level);

    ASSERT_EQ(node.get_first_addr(), start_addr);
    ASSERT_EQ(node.get_last_addr(), end_addr);
    ASSERT_EQ(node.get_level(), level);
    ASSERT_EQ(node.get_memory_region_id(), 0);
    
    for (auto i = 0; i < 16; i++) {
        ASSERT_EQ(node.get_child(i), nullptr);
    }

    for (const auto* child : node.get_children()) {
        ASSERT_EQ(child, nullptr);
    }
}

TEST_F(MRTNodeTest2, testGetChildIndex) {
    const auto start_addr = 0x1200000000000000LL;
    const auto end_addr = 0x12FFFFFFFFFFFFFFLL;
    
    const auto level = 2;

    const auto node = MRTNode2(start_addr, end_addr, level);

    const auto base_addr = 0x010000000000000LL;
    for (auto i = 0; i < 16; i++) {
        const auto inquiry_addr = start_addr + (base_addr * i);
        const auto calculated_index = node.get_child_index(inquiry_addr);

        ASSERT_EQ(calculated_index, i);
    }

    ASSERT_EQ(node.get_child_index(start_addr - 1), -1);
    ASSERT_EQ(node.get_child_index(end_addr + 1), -1);
    ASSERT_EQ(node.get_child_index(0x1100000000000000LL), -1);
    ASSERT_EQ(node.get_child_index(0x1400000000000000LL), -1);
    ASSERT_EQ(node.get_child_index(0x1863453534300000LL), -1);
    ASSERT_EQ(node.get_child_index(0x0000000000000000LL), -1);
    ASSERT_EQ(node.get_child_index(0x1000000000000000LL), -1);
    ASSERT_EQ(node.get_child_index(0x2000000000000000LL), -1);
    ASSERT_EQ(node.get_child_index(0xEFFFFFFFFFFFFFFFLL), -1);
}

TEST_F(MRTNodeTest2, testAddChild0) {
    const auto start_addr = 0x1000000000000000LL;
    const auto end_addr = 0x1FFFFFFFFFFFFFFFLL;

    const auto level = 1;

    auto node = MRTNode2(start_addr, end_addr, level);

    node.add_child(0);

    for (auto i = 0; i < 16; i++) {
        if (i == 0) {
            ASSERT_NE(node.get_child(i), nullptr);
            ASSERT_EQ(node.get_child(i)->get_first_addr(), 0x1000000000000000LL) << std::hex << node.get_child(i)->get_first_addr();
            ASSERT_EQ(node.get_child(i)->get_last_addr(), 0x10FFFFFFFFFFFFFFLL) << std::hex << node.get_child(i)->get_last_addr();
            ASSERT_EQ(node.get_child(i)->get_level(), 2);

            for (auto j = 0; j < 16; j++) {
                ASSERT_EQ(node.get_child(i)->get_child(j), nullptr);
            }
        } else {
            ASSERT_EQ(node.get_child(i), nullptr);
        }
    }
}

TEST_F(MRTNodeTest2, testAddChild1) {
    const auto start_addr = 0x2E00000000000000LL;
    const auto end_addr = 0x2EFFFFFFFFFFFFFFLL;

    const auto level = 2;

    auto node = MRTNode2(start_addr, end_addr, level);

    node.add_child(3);

    for (auto i = 0; i < 16; i++) {
        if (i == 3) {
            ASSERT_NE(node.get_child(i), nullptr);
            ASSERT_EQ(node.get_child(i)->get_first_addr(), 0x2E30000000000000LL) << std::hex << node.get_child(i)->get_first_addr();
            ASSERT_EQ(node.get_child(i)->get_last_addr(), 0x2E3FFFFFFFFFFFFFLL) << std::hex << node.get_child(i)->get_last_addr();
            ASSERT_EQ(node.get_child(i)->get_level(), 3);

            for (auto j = 0; j < 16; j++) {
                ASSERT_EQ(node.get_child(i)->get_child(j), nullptr);
            }
        } else {
            ASSERT_EQ(node.get_child(i), nullptr);
        }
    }
}

TEST_F(MRTNodeTest2, testSetMemoryRegionId) {
    const auto start_addr = 0x1000000000000000LL;
    const auto end_addr = 0x1FFFFFFFFFFFFFFFLL;

    const auto level = 1;

    auto node = MRTNode2(start_addr, end_addr, level);

    const auto memory_region_id = 0x1234;
    node.set_memory_region_id(memory_region_id);

    ASSERT_EQ(node.get_memory_region_id(), memory_region_id);
}
