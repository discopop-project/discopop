#!/bin/bash

# Required Information
#BC_IN="example.bc" # if BC_IN is set, the SRC_FILES and INCLUDE_DIRS are not used
#SRC_FILES="src/example1.c src/example2.c"
#INCLUDE_DIRS="common"

# Additional Required Information
# these are the default values that will be used when the vars are not set
DEF_NAME="reduction" # name of the final executable
DEF_FMAP="./FileMapping.txt"
DEF_BIN_DIR="." # the destination of the generated code / program
DEF_MODULE_LIB="./libModuleFunc.so"
DEF_LOOP_COUNTER_LIB="./loop_counter_lib.bc"

# Compiler Options
LLVM_OPT=opt-8
LLVM_CC=clang-8
LLVM_CXX=clang++-8
LLVM_LINK=llvm-link
COMPILER_FLAGS="-g -O0 -c -emit-llvm"
#COMPILER_FLAGS=$COMPILER_FLAGS" -fno-discard-value-names"

# == check if the required parameters are set ==================================
if [[ "$BC_IN" = "" && "$SRC_FILES" = "" ]]; then
	echo "Error: no binary or src files defined"
	exit
fi

# == set the defualt values for undefined parameters ===========================
if [ "$NAME" = "" ]; then
	NAME=$DEF_NAME
fi
if [ "$FMAP" = "" ]; then
	FMAP=$DEF_FMAP
fi
if [ "$BIN_DIR" = "" ]; then
	BIN_DIR=$DEF_BIN_DIR
fi
if [ "$MODULE_LIB" = "" ]; then
	MODULE_LIB=$DEF_MODULE_LIB
fi
if [ "$LOOP_COUNTER_LIB" = "" ]; then
	LOOP_COUNTER_LIB=$DEF_LOOP_COUNTER_LIB
fi

BC_OUT=$BIN_DIR/$NAME".bc"
BC_OUT_S=$BIN_DIR/$NAME"_in.bc"

# == compile the source files or use the specified binary ======================
if [ ! "$BC_IN" = "" ]; then
	BC_OUT=$BC_IN
else
	INC_STR=""
	for inc_dir in $INCLUDE_DIRS; do
		INC_STR="$INC_STR -I $inc_dir "
	done

	# compile the individual source files
	OUT_FILES=""
	for src_file in $SRC_FILES; do
		OUT_NAME=$(basename "$src_file")
		OUT_NAME="$BIN_DIR/${OUT_NAME%.*}.bc"
		$LLVM_CC $COMPILER_FLAGS $INC_STR $src_file -o $OUT_NAME
		OUT_FILES="$OUT_FILES $OUT_NAME"
	done

	# link them
	$LLVM_LINK $OUT_FILES -o $BC_OUT
fi

# == run the reduction detection ===============================================
CMD_A="$LLVM_OPT -load $MODULE_LIB -modulefunc $BC_OUT -fmap $FMAP -o $BC_OUT_S"
CMD_B="$LLVM_CXX $BC_OUT_S $LOOP_COUNTER_LIB -o $BIN_DIR/$NAME"
CMD_C="time $BIN_DIR/$NAME"
CMD_D="python3 reduction_pass2.py reduction.txt $FMAP"
CMD_E="mv _reduction.txt reduction.txt"

$CMD_A && $CMD_B && $CMD_C && $CMD_D && $CMD_E
