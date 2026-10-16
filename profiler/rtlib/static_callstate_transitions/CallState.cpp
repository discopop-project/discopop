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

#include "CallState.hpp"

void CallState::RegisterTransition(std::int32_t trigger_instruction, CallState* target_state) {
  transitions_[trigger_instruction] = target_state;
  if (trigger_instruction == kFallthroughTrigger) {
    fallthrough_transition_target_ = target_state;
  } else if (trigger_instruction == kReturnTrigger) {
    return_transition_target_ = target_state;
  }
}

void CallState::RegisterImplicitReturnTransition(CallState* target_state) {
  implicit_return_transition_target_ = target_state;
  // A transition registered under the return trigger wins, whichever of the two arrives first:
  // that is the order update_callstate_from_func_exit asked the two questions in.
  if (transitions_.find(kReturnTrigger) == transitions_.end()) {
    return_transition_target_ = target_state;
  }
}

int32_t CallState::GetId() const { return id_; }

CallState* CallState::GetTransitionTarget(int32_t trigger_instruction) const {
  const auto pos = transitions_.find(trigger_instruction);
  if (pos == transitions_.end()) {
    return nullptr;
  }
  return pos->second;
}

CallState* CallState::GetImplicitReturnTransitionTarget() const { return implicit_return_transition_target_; }

CallState* CallState::GetFallthroughTransitionTarget() const { return fallthrough_transition_target_; }

CallState* CallState::GetReturnTransitionTarget() const { return return_transition_target_; }
