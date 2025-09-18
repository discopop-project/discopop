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
#pragma once
#include "CallState.hpp"
#include <unordered_map>

 class CallStateGraph{
    private:
        std::unordered_map<int32_t, CallState*> node_map;
    public:
        CallStateGraph();
        ~CallStateGraph();
        CallState* get_or_register_node(int32_t call_state_id);
        void register_transition(int32_t source_call_state_id, int32_t trigger_instruction, int32_t target_call_state_id);
 };
