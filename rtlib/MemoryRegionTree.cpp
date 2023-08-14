#include "MemoryRegionTree.hpp"


MemoryRegionTree::MemoryRegionTree(){
    if(MRTVerbose)
        cout << "DBG: MRT: creating new Tree.\n";
    root = new MRTNode(0xFFFFFFFFFFFFFFFF, -1);
    if(MRTVerbose)
        cout << "DBG: MRT: Done.\n";
}

void MemoryRegionTree::allocate_region(ADDR startAddr, ADDR endAddr, int64_t memoryRegionId, int32_t *tempAddrCount, int32_t NUM_WORKERS){
    if(MRTVerbose)
        cout << "DBG: MRT: allocating: " << startAddr << " - " << endAddr << " as " << memoryRegionId << "\n";
    
    // create leaf node for start of the allocated region
    MRTNode *currentNode = root;
    MRTNode* next_level_node = nullptr;
    ADDR current_addr = 0x0;
    int level = 0;
    for (; level < 16; level++){
        cout << "Level start: " << level <<  "\n";
        int64_t char_at_level = get_char_at_level(startAddr, level);
        cout << "char_at_level: " << char_at_level << "\n";
        cout << "currentNode: " << currentNode << "\n";
        cout << "currentAddr pre shift: " << current_addr << "\n";
        // append char to currently visited address
        current_addr = current_addr | (((char_at_level << 60) >> (4 * level)) & get_level_shifting_mask(level));
        cout << "currentAddr post shift: " << current_addr << "\n";
        // traverse tree downwards
        cout << "before child access\n";
        cout << "child_arr_ptr: " << currentNode->children << "\n";
        for(int i = 1; i < 16; i++){
            cout << "Child: " << i << " " << currentNode->children[i] << "\n";
        }
        next_level_node = currentNode->children[char_at_level];
        cout << "after traverse down\n";
        if(next_level_node == nullptr){
            // create next node
            next_level_node = new MRTNode(currentNode, current_addr, level);
            currentNode->children[char_at_level] = next_level_node;
        }
        cout << "after if\n";
        // proceed to next level
        currentNode = next_level_node;
        next_level_node = nullptr;
        cout << "Level end\n";
    }
    if(MRTVerbose)
        cout << "DBG: MRT: found leaf node for startAddr: " << startAddr << "\n";
    // set memory region id in lead node
    cout << "before setting memRegId @ \n";
    cout << "current: " << currentNode << "\n";
    cout <<  "asdf " << currentNode->addr << "\n";
    currentNode->memoryRegionId = memoryRegionId;
    cout << "after setting memRegId\n";


    // traverse upwards to find end address of the region
    MRTNode *parent = nullptr;
    MRTNode *child = nullptr;
    ADDR child_addr = 0;
    for(; level > 0;){
        // get parent at current level
        parent = currentNode->parent;
        // remove region entry if existing
        parent->memoryRegionId = 0;

        // register or set memory region of missing children 
        /*
        cout << "LEVEL: " << level << "\n";
        cout << "\tnode addr: " << currentNode->addr << "\n";
        cout << "\tparent addr: " << parent->addr << "\n";
        */

        for(ADDR child_id = 0; child_id < 16; child_id++){
            child = parent->children[child_id];
            // construct addr of child
            child_addr = parent->addr;
            child_addr = (child_addr | (((child_id << 60) >> 4*(level-1)) & get_level_shifting_mask(level-1)));

            // if child is missing create it:                 
            if(child == nullptr){
                
                
                /*
                cout << "\t\tchild_addr pre : " << child_addr << "\n";
                cout << "\t\t\tchild_id: " << child_id << "\n";
                cout << "\t\t\tshifted: " << (child_id << 60) << "\n";
                cout << "\t\t\tback: " << ((child_id << 60) >> 4*(level-1)) << "\n";
                cout << "\t\t\tmask: " << get_level_shifting_mask(level-1) << "\n";
                cout << "\t\t\toffset: " << (((child_id << 60) >> 4*(level-1)) & get_level_shifting_mask(level-1)) << "\n";
                cout << "\t\tchild_addr_post: " << (child_addr | (((child_id << 60) >> 4*(level-1)) & get_level_shifting_mask(level-1))) << "\n";
                */

                // check if child is contained in registered memory region
                if(startAddr > child_addr && child_addr < endAddr){
                    // create node and mark as contained
                    child = new MRTNode(parent, child_addr, level-1);
                    child->memoryRegionId = memoryRegionId;
                    parent->children[child_id] = child;
                    if(MRTVerbose)
                        cout << "Registered missing child to region.\n";
                }
            }
            else{
                // child exists already, overwrite memory region id if necessary
                if(startAddr > child_addr && child_addr < endAddr){
                    child->memoryRegionId = memoryRegionId;
                    if(MRTVerbose)
                        cout << "child exists. Overwritten MemoryRegionId: " << child->memoryRegionId <<  " with " << memoryRegionId << "\n";
                }
            }
        }
        currentNode = currentNode->parent;
        level--;
    }

    // create leaf node for end of the allocated region
    // and create contained children along the way
    //(SEE slide set for example)
    currentNode = root;
    next_level_node = nullptr;
    current_addr = 0x0;
    level = 0;
    for (; level < 16; level++){
        int64_t char_at_level = get_char_at_level(endAddr, level);
        // append char to currently visited address
        cout << "CharatLevel: " << char_at_level << "\n";
        cout << "shifted: " << (char_at_level << 60) << "\n";
        cout << "CurrentAddr 1 pre shift: " << current_addr << "\n";
        ADDR TMPVAL2 = ((char_at_level << 60) >> (4 * level));
        cout << "TMPVAL : " << TMPVAL2 << "\n";
        cout << "Shifting mask: " << get_level_shifting_mask(level) << "\n";
        current_addr = current_addr | (((char_at_level << 60) >> (4 * level)) & get_level_shifting_mask(level));
        cout << "CurrentAddr 1 post shift: " << current_addr << "\n";
        // traverse tree downwards
        next_level_node = currentNode->children[char_at_level];
        if(next_level_node == nullptr){
            // create next node
            next_level_node = new MRTNode(currentNode, current_addr, level);
            currentNode->children[char_at_level] = next_level_node;
        }
        // proceed to next level
        currentNode = next_level_node;
        next_level_node = nullptr;
        // register missing children and mark as contained in region
        // skip last level
        if(level == 15){
            continue;
        }
        for(int64_t j = 0; j < char_at_level; j++){
            child = currentNode->children[j];
            if(child == nullptr){
                // create child node and register region id
                cout << "CurrentNodeAddr 2 pre shift: " << currentNode->addr << "\n";
                cout << "CurrentAddr 2 pre shift: " << current_addr << "\n";
                cout << "j << 60: " << (j << 60) << "\n";
                ADDR TMPVAL0 = (j << 60) >> (4 * (level+1));
                cout << "(j << 60) >> (4* (level +1)): " << TMPVAL0 << "\n";
                ADDR TMPVAL = (((j << 60) >> (4 * (level+1))) & get_level_shifting_mask(level+1));
                cout << "(((j << 60) >> (4 * (level+1))) & get_level_shifting_mask(level+1)): " << TMPVAL << "\n";

                ADDR child_addr = currentNode->addr | (((j << 60) >> (4 * (level+1))) & get_level_shifting_mask(level+1));
                cout << "CurrentAddr 2 post shift: " << child_addr << "\n";
                if(child_addr <= endAddr){
                    MRTNode* child_node = new MRTNode(currentNode, child_addr, level+1);
                    currentNode->children[j] = child_node;
                    child_node->memoryRegionId = memoryRegionId;
                    if(MRTVerbose)
                        cout << "DBG: MRT: registered contained child\n";
                }
            }
        }   
    }
    if(MRTVerbose)
        cout << "DBG: MRT: found leaf node for endAddr: " << endAddr << "\n";
    // set memory region id in leaf node
    currentNode->memoryRegionId = memoryRegionId;
}


string MemoryRegionTree::get_memory_region_id(string fallback, ADDR addr){
    if(MRTVerbose)
        cout << "Retrieving MemoryRegionID for ADDR: " << addr << " --> ";
    MRTNode *currentNode = root;
    MRTNode* next_level_node = nullptr;
    ADDR current_addr = 0x0;
    int level = 0;
    uint memoryRegionId = 0;
    uint readMemoryRegionId = 0;
    int64_t char_at_level = 0;
    for (; level < 16; level++){
        char_at_level = get_char_at_level(addr, level);
        // append char to currently visited address
        current_addr = current_addr | (((char_at_level << 60) >> (4 * level)) & get_level_shifting_mask(level));

        // save memory region of current node for return
        readMemoryRegionId = currentNode->memoryRegionId;
        if(readMemoryRegionId != 0){
            memoryRegionId = readMemoryRegionId;
        }
        

        // traverse tree downwards
        next_level_node = currentNode->children[char_at_level];
        if(next_level_node == nullptr){
            break;
        }
        // proceed to next level
        currentNode = next_level_node;
        next_level_node = nullptr;
    }

    if(MRTVerbose)
        cout << memoryRegionId << "\n";

    if(memoryRegionId == 0){
        return fallback;
    }
    return std::to_string(memoryRegionId);
}