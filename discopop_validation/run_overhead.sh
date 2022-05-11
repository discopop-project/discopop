cd ..

TARGET=$1
echo "TARGET: $TARGET"

timeout 60s python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/overhead_evaluation/$TARGET --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --verbose=true --dp-build-path=/home/lukas/git/discopop/build/ --thread-count=7  --omp-pragmas-file=pragmas.omp  --data-race-output=${PWD}/discopop_validation/test/code_samples/overhead_evaluation/$TARGET/data_races.txt
#--json=original_suggestions.json --validation-time-limit=3
