cd ..

echo "#######################################"
echo "#### SIMPLE_DOALL with data races #### "
echo "#########################################"
echo ""
python -m discopop_validation --path=${PWD}/discopop_validation/test/simple_doall --dep-file=simple_doall_dp_run_dep.txt --ll-file=simple_doall_dp.ll --profiling=true