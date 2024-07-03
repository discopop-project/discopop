/*
 * This file is part of the DiscoPoP software
 * (http://www.discopop.tu-darmstadt.de)
 *
 * Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
 *
 * This software may be modified and distributed under the terms of
 * the 3-Clause BSD License. See the LICENSE file in the package base
 * directory for details.
 *
 */

#include "utils.hpp"
#include "../../share/include/timer.hpp"
#include "../runtimeFunctionsGlobals.hpp"
#include <iostream>

namespace __dp{

DependencyMetadata processQueueElement(MetaDataQueueElement mdqe){
        const auto calltree_timer = Timer(timers, TimerRegion::PROCESSQUEUEELEMENT);

        //cout << "processing " << mdqe.toString() << "\n";

        shared_ptr<CallTreeNode> curr_ctn_node;
        // collect ancestors of sink_ctn
        curr_ctn_node = mdqe.sink_ctn;
        std::set<shared_ptr<CallTreeNode>> sink_ctn_ancestors;
        std::set<unsigned int> sink_ancestor_loops_and_functions;
        if(curr_ctn_node){
            while(curr_ctn_node->get_node_type() != CallTreeNodeType::Root){
                if(curr_ctn_node->get_node_type() == CallTreeNodeType::Loop){
                    // ignore for metadata calculation, but keep for ancestor reporting
                    sink_ancestor_loops_and_functions.insert(curr_ctn_node->get_loop_or_function_id());
                }
                else{
                    sink_ctn_ancestors.insert(curr_ctn_node);
                    // ancestor reporting
                    if(curr_ctn_node->get_node_type() == CallTreeNodeType::Function){
                        sink_ancestor_loops_and_functions.insert(curr_ctn_node->get_loop_or_function_id());
                    }
                }
                
                curr_ctn_node = curr_ctn_node->get_parent_ptr();
                if(!curr_ctn_node){
                    break;
                }
            }
        }

        // collect ancestors of source_ctn
        curr_ctn_node = mdqe.source_ctn;
        std::set<shared_ptr<CallTreeNode>> source_ctn_ancestors;
        std::set<unsigned int> source_ancestor_loops_and_functions;
        if(curr_ctn_node){
            while(curr_ctn_node->get_node_type() != CallTreeNodeType::Root){
                if(curr_ctn_node->get_node_type() == CallTreeNodeType::Loop){
                    // ignore for metadata calculation, but keep for ancestor reporting
                    source_ancestor_loops_and_functions.insert(curr_ctn_node->get_loop_or_function_id());
                }
                else{
                    source_ctn_ancestors.insert(curr_ctn_node);
                    // ancestor reporting
                    if(curr_ctn_node->get_node_type() == CallTreeNodeType::Function){
                        source_ancestor_loops_and_functions.insert(curr_ctn_node->get_loop_or_function_id());
                    }
                }
                
                curr_ctn_node = curr_ctn_node->get_parent_ptr();
                if(!curr_ctn_node){
                    break;
                }
            }
        }

        // determine common ancestors
        std::set<shared_ptr<CallTreeNode>> common_ancestors;
        for(auto sink_anc : sink_ctn_ancestors){
            for(auto source_anc : source_ctn_ancestors){
                if(sink_anc == source_anc){
                    common_ancestors.insert(sink_anc);
                }
            }
        }

        // determine disjoint ancestors
        std::set<shared_ptr<CallTreeNode>> disjoint_sink_ancestors;
        std::set<shared_ptr<CallTreeNode>> disjoint_source_ancestors;
        for(auto sink_anc : sink_ctn_ancestors){
            bool contained = false;
            for(auto source_anc : source_ctn_ancestors){
                if(sink_anc == source_anc){
                    contained = true;
                    break;
                }
            }
            if(!contained){
                disjoint_sink_ancestors.insert(sink_anc);
            }
        }
        for(auto source_anc : source_ctn_ancestors){
            bool contained = false;
            for(auto sink_anc : sink_ctn_ancestors){
                if(source_anc == sink_anc){
                    contained = true;
                    break;
                }
            }
            if(!contained){
                disjoint_source_ancestors.insert(source_anc);
            }
        }
        //cout << "common: " << common_ancestors.size() << " disjoint sink: " << disjoint_sink_ancestors.size() << " source: " << disjoint_source_ancestors.size() << "\n";

        // identify intra_call and intra_iteration dependencies
        std::set<unsigned int> intra_call_dependencies;
        std::set<unsigned int> intra_iteration_dependencies;
        for(auto common_anc : common_ancestors){
            if(common_anc->get_node_type() == CallTreeNodeType::Function){
                intra_call_dependencies.insert(common_anc->get_loop_or_function_id());
            }
            else if(common_anc->get_node_type() == CallTreeNodeType::Iteration){
                intra_iteration_dependencies.insert(common_anc->get_loop_or_function_id());
            }
        }
        //cout << "intra_call: " << intra_call_dependencies.size() << " intra_iteration: " << intra_iteration_dependencies.size() << "\n";

        // identify inter_call and inter_iteration dependencies
        std::set<unsigned int> inter_call_dependencies;
        std::set<unsigned int> inter_iteration_dependencies;
        for(auto disjoint_sink_anc : disjoint_sink_ancestors){
            for(auto disjoint_source_anc : disjoint_source_ancestors){
                // check for inter call dependencies
                if((disjoint_sink_anc->get_node_type() == CallTreeNodeType::Function ) 
                        && (disjoint_source_anc->get_node_type() == CallTreeNodeType::Function) 
                        && (disjoint_sink_anc->get_loop_or_function_id() == disjoint_source_anc->get_loop_or_function_id())){
                    inter_call_dependencies.insert(disjoint_sink_anc->get_loop_or_function_id());
                }
                // check for inter iteration dependencies
                if((disjoint_sink_anc->get_node_type() == CallTreeNodeType::Iteration)
                        && (disjoint_source_anc->get_node_type() == CallTreeNodeType::Iteration)
                        && (disjoint_sink_anc->get_parent_ptr() == disjoint_source_anc->get_parent_ptr())
                        && (disjoint_sink_anc->get_parent_ptr()->get_node_type() == CallTreeNodeType::Loop)
                    ){
                        inter_iteration_dependencies.insert(disjoint_sink_anc->get_loop_or_function_id());
                    }
            }
        }
        //cout << "inter_call: " << inter_call_dependencies.size() << " inter_iteration: " << inter_iteration_dependencies.size() << "\n";

        return DependencyMetadata(mdqe, intra_call_dependencies, intra_iteration_dependencies,
                                  inter_call_dependencies, inter_iteration_dependencies,
                                  sink_ancestor_loops_and_functions, source_ancestor_loops_and_functions);
    }

} // namespace __dp