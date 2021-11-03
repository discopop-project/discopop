cd ..
echo "#######################################"
echo "#### SIMPLE_DOALL with data races #### "
echo "#########################################"
echo ""
#python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/simple_doall/simple --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --json=original_suggestions.json --verbose=true

# PROFILING

# 1 path 3 operations
python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/simple_doall/path_1_op_3 --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --json=original_suggestions.json --verbose=true


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
