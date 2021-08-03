cd ..
echo "#######################################"
echo "#### SIMPLE_DOALL with data races #### "
echo "#########################################"
echo ""
#python -m discopop_validation --path=${PWD}/discopop_validation/test/simple_doall --dep-file=simple_doall_dp_run_dep.txt --ll-file=simple_doall_dp.ll

echo ""
echo "#########################################"
echo "#### SIMPLE_DOALL with no shared operation ####"
echo "#########################################"
echo ""
#python -m discopop_validation --path=${PWD}/discopop_validation/test/simple_doall_no_shared_operation --dep-file=simple_no_dr_dp_run_dep.txt --ll-file=simple_no_dr_dp.ll

echo ""
echo "#########################################"
echo "#### SIMPLE_DOALL WO/ DR READ ####"
echo "#########################################"
echo ""
#python -m discopop_validation --path=${PWD}/discopop_validation/test/simple_doall_no_dr_read --dep-file=simple_no_dr_dp_run_dep.txt --ll-file=simple_no_dr_dp.ll

echo ""
echo "#########################################"
echo "#### SIMPLE_DOALL WO/ DR WRITE ARR ####"
echo "#########################################"
echo ""
#python -m discopop_validation --path=${PWD}/discopop_validation/test/simple_doall_no_dr_write_arr --dep-file=simple_no_dr_dp_run_dep.txt --ll-file=simple_no_dr_dp.ll

echo ""
echo "#########################################"
echo "#### SIMPLE_DOALL WRITE ONLY VAR ####"
echo "#########################################"
echo ""
#python -m discopop_validation --path=${PWD}/discopop_validation/test/simple_doall_write_only --dep-file=simple_no_dr_dp_run_dep.txt --ll-file=simple_no_dr_dp.ll

echo ""
echo "#########################################"
echo "#### SIMPLE_DOALL READ WRITE VAR ####"
echo "#########################################"
echo ""
#python -m discopop_validation --path=${PWD}/discopop_validation/test/simple_doall_read_write --dep-file=simple_no_dr_dp_run_dep.txt --ll-file=simple_no_dr_dp.ll

echo ""
echo "#########################################"
echo "#### SIMPLE_DOALL DEEP ARRAY ####"
echo "#########################################"
echo ""
#python -m discopop_validation --path=${PWD}/discopop_validation/test/simple_doall_deep_arr --dep-file=simple_no_dr_dp_run_dep.txt --ll-file=simple_no_dr_dp.ll

echo ""
echo "#########################################"
echo "#### SIMPLE_DOALL - FUNCTION CALL - SINGLE LEVEL####"
echo "#########################################"
echo ""
#python -m discopop_validation --path=${PWD}/discopop_validation/test/simple_doall_function_call --dep-file=simple_no_dr_dp_run_dep.txt --ll-file=simple_no_dr_dp.ll

echo ""
echo "#########################################"
echo "#### SIMPLE_DOALL - FUNCTION CALL - TWO LEVELS####"
echo "#########################################"
echo ""
# python -m discopop_validation --path=${PWD}/discopop_validation/test/simple_doall_two_level_call --dep-file=simple_no_dr_dp_run_dep.txt --ll-file=simple_no_dr_dp.ll

echo ""
echo "#########################################"
echo "#### SIMPLE_DOALL - SIMPLE RECURSION ####"
echo "#########################################"
echo ""
# python -m discopop_validation --path=${PWD}/discopop_validation/test/simple_doall_recursive --dep-file=simple_no_dr_dp_run_dep.txt --ll-file=simple_no_dr_dp.ll

echo ""
echo "#########################################"
echo "#### BOTS - OWN FIB ####"
echo "#########################################"
echo ""
#python -m discopop_validation --path=/home/lukas/Schreibtisch/bots/own_fib/discopop-tmp --dep-file=own_fib_dp_run_dep.txt --ll-file=own_fib_dp.ll

echo ""
echo "#########################################"
echo "#### BOTS - OWN NQUEENS ####"
echo "#########################################"
echo ""
#python -m discopop_validation --path=/home/lukas/Schreibtisch/bots/own_nqueens/discopop-tmp --dep-file=own_nqueens_dp_run_dep.txt --ll-file=own_nqueens_dp.ll

echo ""
echo "#########################################"
echo "#### POLYBENCH - ATAX ####"
echo "#########################################"
echo ""
python -m discopop_validation --path=/home/lukas/Dokumente/Hiwi/polybench/atax_only/discopop/ --dep-file=dp_run_dep.txt --ll-file=complete.ll
