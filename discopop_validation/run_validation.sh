#cd ..
echo "#######################################"
echo "#### SIMPLE_DOALL with data races #### "
echo "#########################################"
echo ""
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/simple_doall/simple --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --json=original_suggestions.json --verbose=true


echo ""
echo "#########################################"
echo "#### POLYBENCH - ATAX ####"
echo "#########################################"
echo ""
#python -m discopop_validation --path=/home/lukas/git/DP_Maker/atax_Makefile/ --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --json=original_suggestions.json

echo ""
echo "#########################################"
echo "#### POLYBENCH - 2MM ####"
echo "#########################################"
echo ""
#python -m discopop_validation --path=/home/lukas/Dokumente/Hiwi/polybench/2mm_Makefile/ --dep-file=out_dep.txt --ll-file=out_dp_inst.ll


echo ""
echo "#########################################"
echo "#### BOTS - fft ####"
echo "#########################################"
echo ""
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/bots_reduced/serial/fft --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --json=original_suggestions.json --verbose=true


# PROFILING
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/simple_doall/path_1_op_3 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --json=original_suggestions.json --verbose=true#
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/simple_doall/path_1_op_6 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --json=original_suggestions.json --verbose=true --call-graph=/home/lukas/Schreibtisch/cg.png --dp-build-path=/home/lukas/git/discopop/build/
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/simple_doall/path_1_op_7 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --json=original_suggestions.json --verbose=true --dp-build-path=/home/lukas/git/discopop/build/
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/simple_doall/path_1_op_8 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --json=original_suggestions.json --verbose=true --dp-build-path=/home/lukas/git/discopop/build/
#--call-graph=/home/lukas/Schreibtisch/cg.png
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/simple_doall/path_1_op_9 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --verbose=true --dp-build-path=/home/lukas/git/discopop/build/ --thread-count=7 --omp-pragmas-file=omp_pragmas.txt #--json=original_suggestions.json #  --call-graph=/home/lukas/Schreibtisch/cg.png --data-race-output=data_races.txt --validation-time-limit=3
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/simple_doall/path_1_op_9 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --json=original_suggestions.json --verbose=true --dp-build-path=/home/lukas/git/discopop/build/
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/simple_doall/path_1_op_12 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --json=original_suggestions.json --verbose=true --dp-build-path=/home/lukas/git/discopop/build/

# DATARACE BENCHMARK
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/benchmark_datarace/do_all/DRB045 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --json=manual_suggestions.json --verbose=true
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/benchmark_datarace/do_all/DRB046 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --json=manual_suggestions.json --verbose=true
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/benchmark_datarace/do_all/DRB047 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --json=manual_suggestions.json --verbose=true
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/benchmark_datarace/do_all/DRB073 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --json=manual_suggestions.json --verbose=true --call-graph=/home/lukas/Schreibtisch/cg.png --dp-build-path=/home/lukas/git/discopop/build/
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/benchmark_datarace/do_all/DRB093 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --json=manual_suggestions.json --verbose=true --call-graph=/home/lukas/Schreibtisch/cg.png --dp-build-path=/home/lukas/git/discopop/build/
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/benchmark_datarace/do_all/DRB094 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --json=manual_suggestions.json --verbose=true
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/benchmark_datarace/do_all/DRB095 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --json=manual_suggestions.json --verbose=true
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/benchmark_datarace/do_all/DRB096 --dep-file=out_dep.txt --l-file=out_dp_inst.ll --json=manual_suggestions.json --verbose=true

# REDUCTION
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/simple_reduction/simple --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --verbose=true --dp-build-path=/home/lukas/git/discopop/build/ --thread-count=7  --omp-pragmas-file=pragmas.omp #--json=original_suggestions.json --validation-time-limit=3

# TASKS
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/simple_tasking/simple --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --verbose=true --dp-build-path=/home/lukas/git/discopop/build/ --thread-count=7  --omp-pragmas-file=pragmas.omp #--json=original_suggestions.json --validation-time-limit=3

# DRB106
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/drb/106 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --verbose=true --dp-build-path=/home/lukas/git/discopop/build/ --thread-count=7  --omp-pragmas-file=pragmas.omp #--json=original_suggestions.json --validation-time-limit=3

# DRB117
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/simple_tasking/117 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --verbose=true --dp-build-path=/home/lukas/git/discopop/build/ --thread-count=7  --omp-pragmas-file=pragmas.omp #--json=original_suggestions.json --validation-time-limit=3

# DRB027
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/simple_tasking/027 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --verbose=true --dp-build-path=/home/lukas/git/discopop/build/ --thread-count=7  --omp-pragmas-file=pragmas.omp #--json=original_suggestions.json --validation-time-limit=3

# DRB072
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/simple_tasking/072 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --verbose=true --dp-build-path=/home/lukas/git/discopop/build/ --thread-count=7  --omp-pragmas-file=pragmas.omp #--json=original_suggestions.json --validation-time-limit=3

# DRB078
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/simple_tasking/078 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --verbose=true --dp-build-path=/home/lukas/git/discopop/build/ --thread-count=7  --omp-pragmas-file=pragmas.omp #--json=original_suggestions.json --validation-time-limit=3

# DRB079
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/simple_tasking/079 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --verbose=true --dp-build-path=/home/lukas/git/discopop/build/ --thread-count=7  --omp-pragmas-file=pragmas.omp #--json=original_suggestions.json --validation-time-limit=3

# DRB105
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/simple_tasking/105 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --verbose=true --dp-build-path=/home/lukas/git/discopop/build/ --thread-count=7  --omp-pragmas-file=pragmas.omp #--json=original_suggestions.json --validation-time-limit=3

# DRB131
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/simple_tasking/131 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --verbose=true --dp-build-path=/home/lukas/git/discopop/build/ --thread-count=7  --omp-pragmas-file=pragmas.omp #--json=original_suggestions.json --validation-time-limit=3

# BOTS_REDUCED FIB
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/bots_reduced/serial/fib --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --verbose=true --dp-build-path=/home/lukas/git/discopop/build/ --thread-count=7  --json=original_suggestions.json

#./run_drb.sh 043
./run_drb.sh 045
#./run_drb.sh 047
#./run_drb.sh 131
#./run_drb.sh 165
#./run_drb.sh 027
