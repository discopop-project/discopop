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

#include "lid_constants.hpp"

// masked, because LID is signed: without the mask a loop id with its top bit set -- and the 0xFF
// that update_lid writes when no loop is active -- sign extends into a negative number instead of
// coming back out as the byte that was put in. The other macros below mask already.
constexpr LID unpackLIDMetadata_getLoopID(LID lid) { return (lid >> 56) & 0xFF; }

constexpr LID unpackLIDMetadata_getLoopIteration_0(LID lid) { return (lid >> 48) & 0x7F; }

constexpr LID unpackLIDMetadata_getLoopIteration_1(LID lid) { return (lid >> 40) & 0x7F; }

constexpr LID unpackLIDMetadata_getLoopIteration_2(LID lid) { return (lid >> 32) & 0x7F; }

constexpr LID checkLIDMetadata_getLoopIterationValidity_0(LID lid) { return (lid & 0x0080000000000000) >> 55; }

constexpr LID checkLIDMetadata_getLoopIterationValidity_1(LID lid) { return (lid & 0x0000800000000000) >> 47; }

constexpr LID checkLIDMetadata_getLoopIterationValidity_2(LID lid) { return (lid & 0x0000008000000000) >> 39; }
