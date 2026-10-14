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

#include "DPTypes.hpp"
#include "memory/AbstractShadow.hpp"
#include "runtimeFunctionsTypes.hpp"

#include <string>

namespace __dp {

/******* Helper functions *******/
void addDep(depType type, LID curr, LID depOn, const char *var, std::int64_t AAvar, ADDR addr);

void outputDeps();

void generateStringDepMap();

void readRuntimeInfo();

void initParallelization();

void initSingleThreadedExecution();

void mergeDeps();

// void *analyzeDeps(void *arg);

void *processFirstAccessQueue(void *arg);

void *processSecondAccessQueue(void *arg);

void analyzeSingleAccess(__dp::AbstractShadow *SMem, __dp::AccessInfo &access);

// the dependency analysis of one access on the calling thread, used if NUM_WORKERS==0
void analyzeSingleAccessOnMainThread(__dp::AccessInfo &access);

void finalizeParallelization();

void finalizeSingleThreadedExecution();

} // namespace __dp
