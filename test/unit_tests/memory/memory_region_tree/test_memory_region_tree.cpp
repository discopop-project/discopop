#include <gtest/gtest.h>

#include "../../../../rtlib/memory/MemoryRegionTree.hpp"

#include <cstdint>
#include <vector>

// Tests for old version (i.e., capturing functionality)

class MemoryRegionTreeTest : public ::testing::Test { };

TEST_F(MemoryRegionTreeTest, testConstructor) {
    const auto mrt = MemoryRegionTree{};

    const auto* root = mrt.get_root();

    ASSERT_EQ(root->addr, 0xFFFFFFFFFFFFFFFF);
    ASSERT_EQ(root->level, -1);
    ASSERT_EQ(root->parent, nullptr);
    ASSERT_EQ(root->memoryRegionId, 0);

    for (auto i = 0; i < 16; i++) {
        ASSERT_EQ(root->children[i], nullptr);
    }
}

TEST_F(MemoryRegionTreeTest, testAllocateRegion1) {
    auto mrt = MemoryRegionTree{};

    const auto start_addr = 0x1000000000000000ULL;
    const auto end_addr = 0x2000000000000000ULL;

    const auto memory_region_id = 45LL;

    mrt.allocate_region(start_addr, end_addr, memory_region_id);

    const auto* root = mrt.get_root();

    ASSERT_EQ(root->addr, 0xFFFFFFFFFFFFFFFF);
    ASSERT_EQ(root->level, -1);
    ASSERT_EQ(root->parent, nullptr);
    ASSERT_EQ(root->memoryRegionId, 0);

    for (auto i = 0; i < 16; i++) {
        const auto* child = root->children[i];
        ASSERT_NE(child, nullptr);

        ASSERT_EQ(child->level, 0);
        ASSERT_EQ(child->parent, root);

        ASSERT_EQ(child->memoryRegionId, 45);
    }
}

TEST_F(MemoryRegionTreeTest, testAllocateRegion2) {
    auto mrt = MemoryRegionTree{};

    const auto start_addr = 0x0040000000000000ULL;
    const auto end_addr = 0x0080000000000000ULL;

    const auto memory_region_id = 12LL;

    mrt.allocate_region(start_addr, end_addr, memory_region_id);

    const auto* root = mrt.get_root();

    ASSERT_EQ(root->addr, 0xFFFFFFFFFFFFFFFF);
    ASSERT_EQ(root->level, -1);
    ASSERT_EQ(root->parent, nullptr);
    ASSERT_EQ(root->memoryRegionId, 0);

    for (auto i = 0; i < 16; i++) {
        const auto* child = root->children[i];
        ASSERT_NE(child, nullptr);

        ASSERT_EQ(child->level, 0);
        ASSERT_EQ(child->parent, root);

        ASSERT_EQ(child->memoryRegionId, 12);

        for (auto j = 0; j < 16; j++) {
            const auto* grandchild = child->children[j];
            
            if (j == 0 && i == 0) {
                ASSERT_NE(grandchild, nullptr);
            } else {
                ASSERT_EQ(grandchild, nullptr);
            }
        }
    }

    const auto* descendent = root->children[0]->children[0];

    ASSERT_NE(descendent, nullptr);
    ASSERT_EQ(descendent->addr, 0ULL);
    ASSERT_EQ(descendent->level, 1);
    ASSERT_EQ(descendent->parent, root->children[0]);
    ASSERT_EQ(descendent->memoryRegionId, 12);

    ASSERT_NE(descendent->children[0], nullptr);
    ASSERT_NE(descendent->children[1], nullptr);
    ASSERT_NE(descendent->children[2], nullptr);
    ASSERT_NE(descendent->children[3], nullptr);
    ASSERT_NE(descendent->children[4], nullptr);
    ASSERT_EQ(descendent->children[5], nullptr);
    ASSERT_EQ(descendent->children[6], nullptr);
    ASSERT_EQ(descendent->children[7], nullptr);
    ASSERT_NE(descendent->children[8], nullptr);
    ASSERT_EQ(descendent->children[9], nullptr);
    ASSERT_EQ(descendent->children[10], nullptr);
    ASSERT_EQ(descendent->children[11], nullptr);
    ASSERT_EQ(descendent->children[12], nullptr);
    ASSERT_EQ(descendent->children[13], nullptr);
    ASSERT_EQ(descendent->children[14], nullptr);
    ASSERT_EQ(descendent->children[15], nullptr);

    // TODO(Lukas): Add some further sense for this test?
}
