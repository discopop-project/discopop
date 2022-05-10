cd ..

TARGET=$1
echo "TARGET: $TARGET"

python -m discopop_validation --path=${PWD}/discopop_validation/test/code_samples/discopop/$TARGET --dep-file=out_dep.txt --ll-file=out_dp_inst.ll --verbose=true --dp-build-path=/home/lukas/git/discopop/build/ --thread-count=7  --json=original_suggestions.json  --data-race-output=${PWD}/discopop_validation/test/code_samples/discopop/$TARGET/data_races.txt
