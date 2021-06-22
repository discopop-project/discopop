cd ..
echo "#######################################"
echo "#### SIMPLE_DOALL with data races #### "
echo "#########################################"
echo ""
python -m discopop_validation --path=${PWD}/discopop_validation/test/simple_doall --dep-file=simple_doall_dp_run_dep.txt --ll-file=simple_doall_dp.ll

echo ""
echo "#########################################"
echo "#### SIMPLE_DOALL with no shared operation ####"
echo "#########################################"
echo ""
python -m discopop_validation --path=${PWD}/discopop_validation/test/simple_doall_no_shared_operation --dep-file=simple_no_dr_dp_run_dep.txt --ll-file=simple_no_dr_dp.ll

echo ""
echo "#########################################"
echo "#### SIMPLE_DOALL WO/ DR READ ####"
echo "#########################################"
echo ""
python -m discopop_validation --path=${PWD}/discopop_validation/test/simple_doall_no_dr_read --dep-file=simple_no_dr_dp_run_dep.txt --ll-file=simple_no_dr_dp.ll

echo ""
echo "#########################################"
echo "#### SIMPLE_DOALL WO/ DR WRITE ####"
echo "#########################################"
echo ""
python -m discopop_validation --path=${PWD}/discopop_validation/test/simple_doall_no_dr_write --dep-file=simple_no_dr_dp_run_dep.txt --ll-file=simple_no_dr_dp.ll