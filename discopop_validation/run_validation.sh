cd ..
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
python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/simple_doall/path_1_op_9 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --json=original_suggestions.json --verbose=true --dp-build-path=/home/lukas/git/discopop/build/ --validation-time-limit=5 --thread-count=7
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
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/benchmark_datarace/do_all/DRB096 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --json=manual_suggestions.json --verbose=true
