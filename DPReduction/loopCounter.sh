#!/bin/bash
insertLine=""
add=":"
space=" "
line=$(head -n 1 "loop_counter_output.txt")
echo $line
for loopLine in $line
do
    echo $loopLine
	loopLine=$loopLine$add$loopLine
	insertLine=$insertLine$loopLine
	insertLine=$insertLine$space
done
echo $insertLine
sed -i '1d' loop_counter_output.txt
echo $insertLine | cat - "loop_counter_output.txt" > temp && mv temp "loop_counter_output.txt"
