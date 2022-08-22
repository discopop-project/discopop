HOME_DIR=$PWD
DP_MAKER_DIR=/home/lukas/git/DP_Maker
TARGET_PROJECT_FOLDER=$HOME_DIR
TARGET_FOLDER=$HOME_DIR

cd $TARGET_FOLDER
make clean

cd $DP_MAKER_DIR
python -m Makefile_Analyzer --target-project=$TARGET_PROJECT_FOLDER --target-makefile=$TARGET_FOLDER/Makefile --dp-path=/home/lukas/git/discopop/ --dp-build-path=/home/lukas/git/discopop/build/ --exec-mode=dep
cd $TARGET_FOLDER && make -j3 -f tmp_makefile.mk && ./out

cd $DP_MAKER_DIR
python -m Makefile_Analyzer --target-project=$TARGET_PROJECT_FOLDER --target-makefile=$TARGET_FOLDER/Makefile --dp-path=/home/lukas/git/discopop/ --dp-bui=/home/lukas/git/discopop/build/ --exec-mode=cu_gen
cd $TARGET_FOLDER && make -j3 -f tmp_makefile.mk && ./out

cd $DP_MAKER_DIR
python -m Makefile_Analyzer --target-project=$TARGET_PROJECT_FOLDER --target-makefile=$TARGET_FOLDER/Makefile --dp-path=/home/lukas/git/discopop/ --dp-bui=/home/lukas/git/discopop/build/ --exec-mode=dp_red
cd $TARGET_FOLDER && make -j3 -f tmp_makefile.mk && ./out

./create_suggestions.sh

cd $HOME_DIR
