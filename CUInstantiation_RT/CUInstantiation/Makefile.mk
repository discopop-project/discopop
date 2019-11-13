#===- lib/CUInstantiation/Makefile.mk ---------------------------------*- Makefile -*--===#
#
#                     The LLVM Compiler Infrastructure
#
# This file is distributed under the University of Illinois Open Source
# License. See LICENSE.TXT for details.
#
#===------------------------------------------------------------------------===#

ModuleName := CUInstantiation
SubDirs :=

Sources := $(foreach file,$(wildcard $(Dir)/*.cpp),$(notdir $(file)))
ObjNames := $(Sources:%.cpp=%.o)

Implementation := Generic

# FIXME: use automatic dependencies?
Dependencies := $(wildcard $(Dir)/*.h)

# Define a convenience variable for all the CUInst functions.
CUInstantiationFunctions := $(Sources:%.cpp=%)
