HOME_DIR=$PWD
# change to discopop directory
cd ../../../../..

python -m discopop_explorer --path=$HOME_DIR --dep-file=out_dep.txt --dp-build-path=/home/lukas/git/discopop/build --json=$HOME_DIR/original_suggestions.json --dump-pet=pet_dump.json
