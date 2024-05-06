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

#include "../include/timer.hpp"

std::vector<Timers::time_point> Timers::time_start{ NUMBER_TIMERS };
std::vector<Timers::time_point> Timers::time_stop{ NUMBER_TIMERS };

std::vector<std::size_t> Timers::number_called(NUMBER_TIMERS, std::size_t(0));
std::vector<std::chrono::nanoseconds> Timers::time_elapsed{ NUMBER_TIMERS };
