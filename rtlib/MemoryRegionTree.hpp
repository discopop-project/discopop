#include "DPUtils.hpp"

#define MRTVerbose false

#define get_char_at_level(addr, level) (((addr << (level*4)) >> 60) & 0x000000000000000F)

inline ADDR get_level_shifting_mask(int level){
    switch (level)
    {
    case 0:
        return 0xF000000000000000;
    case 1:
        return 0x0F00000000000000;
    case 2:
        return 0x00F0000000000000;
    case 3:
        return 0x000F000000000000;
    case 4:
        return 0x0000F00000000000;
    case 5:
        return 0x00000F0000000000;
    case 6:
        return 0x000000F000000000;    
    case 7:
        return 0x0000000F00000000;
    case 8:
        return 0x00000000F0000000;
    case 9:
        return 0x000000000F000000;
    case 10:
        return 0x0000000000F00000;
    case 11:
        return 0x00000000000F0000;
    case 12:
        return 0x000000000000F000;
    case 13:
        return 0x0000000000000F00;
    case 14:
        return 0x00000000000000F0;
    case 15:
        return 0x000000000000000F;
    default:
        return 0xFFFFFFFFFFFFFFFF;
    }
}

struct MRTNode {
    // Constructors
    MRTNode() = delete;
    MRTNode(const MRTNode&) = delete;

    MRTNode(ADDR addr_i, short level)
        : addr(addr_i), level(level), children{}
        {
            if(MRTVerbose)
                cout << "DBG: MRT: Creating Node addr: " << addr << " at level: " << level << " childArrPtr: " << children <<"\n"; 
        };
    MRTNode(MRTNode* parent_node, ADDR addr_i, short level)
        : parent(parent_node), addr(addr_i), level(level), children{}
        {
            if(MRTVerbose)
                cout << "DBG: MRT: Creating Node addr: " << addr << " at level: " << level << " with parent addr: " << parent_node->addr << " childArrPtr: " << children << "\n"; 
        };
    MRTNode(MRTNode* parent_node, ADDR addr_i, uint memRegId, short level)
        : parent(parent_node), addr(addr_i), memoryRegionId(memRegId), level(level), children{}
        {
            if(MRTVerbose)
                cout << "DBG: MRT: Creating Node addr: " << addr << " at level: " << level << " childArrPtr: " << children << "\n"; 
        };
    
    // Values
    ADDR addr;
    short level;
    MRTNode *parent;
    uint memoryRegionId;
    MRTNode *children[16];  // 16 to split 64 bit addresses into 16 levels using Hex representation
};


struct MemoryRegionTree
{
    // Constructors
    MemoryRegionTree();
    // Destructors
    ~MemoryRegionTree();  // TODO

    // Functions
    void allocate_region(ADDR startAddr, ADDR endAddr, int64_t memory_region_id, int32_t *tempAddrCount, int32_t NUM_WORKERS); // TODO-WIP
    void free_region(ADDR startADDR); // TODO
    string get_memory_region_id(string fallback, ADDR addr); // TODO
    void wait_for_empty_chunks(int32_t *tempAddrCount, int32_t NUM_WORKERS);

    // Values
    MRTNode *root;  // Root has ADDR 0xFF...FF and level -1 such that level 0 corresponds to first character of hex code
};
