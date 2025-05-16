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

#include "CallTree.hpp"


namespace __dp {
CallTree::CallTree(): ctnqcb(CallTreeNodeQueueChunkBuffer(10)){
  current = make_shared<CallTreeNode>();
  prepared_chunk = ctnqcb.get_prepared_chunk(100);

  // spawn CallTree management thread
  calltree_thread_stop = false;
  pthread_attr_t attr;
  pthread_attr_init(&attr);
  pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
  pthread_create(&calltree_thread, &attr, manage_calltree, this);
  pthread_attr_destroy(&attr);
}

CallTree::~CallTree() {
  // join CallTree management thread
  calltree_thread_stop = true;
  pthread_join(calltree_thread, NULL);
  std::cout << "Joined calltree_thread" << std::endl;
}

unsigned int CallTree::get_node_count() { return call_tree_node_count.load(); }

std::shared_ptr<CallTreeNode> CallTree::get_current_node_ptr() { return current; }

void CallTree::enter_function(unsigned int function_id) {
  if (prepared_chunk->buffer_empty()){
    delete prepared_chunk;
    prepared_chunk = ctnqcb.get_prepared_chunk(100);
  }
  std::shared_ptr<CallTreeNode> new_node = std::move(prepared_chunk->get_prepared_node());
  new_node->set(current, CallTreeNodeType::Function, function_id, 0);
  current = std::move(new_node);
}

void CallTree::enter_loop(unsigned int loop_id) {
  if (prepared_chunk->buffer_empty()){
    delete prepared_chunk;
    prepared_chunk = ctnqcb.get_prepared_chunk(100);
  }
  std::shared_ptr<CallTreeNode> new_node = std::move(prepared_chunk->get_prepared_node());
  new_node->set(current, CallTreeNodeType::Loop, loop_id, 0);
  current = std::move(new_node);
}

void CallTree::enter_iteration(unsigned int iteration_id) {
  // identify loop id of nearest loop
  shared_ptr<CallTreeNode> node_ptr = std::move(get_current_node_ptr());
  if (!node_ptr) {
    return;
  }
  unsigned int loop_id = 0;
  while (node_ptr.get()->get_node_type() != CallTreeNodeType::Root) {
    if (node_ptr.get()->get_node_type() == CallTreeNodeType::Loop) {
      // found nearest loop node
      loop_id = node_ptr.get()->get_loop_or_function_id();
      break;
    }
    // continue search with parent node
    node_ptr = std::move(node_ptr.get()->get_parent_ptr());
  }
  // create iteration node
  if (prepared_chunk->buffer_empty()){
    delete prepared_chunk;
    prepared_chunk = ctnqcb.get_prepared_chunk(100);
  }
  std::shared_ptr<CallTreeNode> new_node = std::move(prepared_chunk->get_prepared_node());
  new_node->set(std::move(node_ptr), CallTreeNodeType::Iteration, loop_id, iteration_id);
  current = std::move(new_node);
}

void CallTree::exit_function() {
  // set current to the parent of the closest function
  shared_ptr<CallTreeNode> node_ptr = std::move(get_current_node_ptr());
  if (!node_ptr) {
    return;
  }
  while (node_ptr->get_node_type() != CallTreeNodeType::Root) {
    if (node_ptr->get_node_type() == CallTreeNodeType::Function) {
      // found closest function node
      break;
    }
    // continue search with parent
    node_ptr = std::move(node_ptr->get_parent_ptr());
  }
  current = std::move(node_ptr->get_parent_ptr());
}

void CallTree::exit_loop() {
  // set current to the parent of the closest loop
  shared_ptr<CallTreeNode> node_ptr = std::move(get_current_node_ptr());
  if (!node_ptr) {
    return;
  }
  while (node_ptr->get_node_type() != CallTreeNodeType::Root) {
    if (node_ptr->get_node_type() == CallTreeNodeType::Loop) {
      // found closest loop node
      break;
    }
    // continue search with parent
    node_ptr = std::move(node_ptr->get_parent_ptr());
  }
  current = std::move(node_ptr->get_parent_ptr());
}

void* manage_calltree(void* arg){
  std::cout << "Hello world from CallTree manager thread!" << std::endl;
  CallTree* call_tree_ptr = (CallTree*) arg;
  while(! calltree_thread_stop){
    call_tree_ptr->ctnqcb.prepare_chunk_if_required(10000);
    usleep(500);  // todo: automatic tuning
  }
  pthread_exit(NULL);
  return nullptr;
}

} // namespace __dp
