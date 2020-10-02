#!/bin/bash

for d in */ ; do
    basename $d
    PYTHONPATH=.. python3 -m discopop_explorer --path "$PWD/$d/data" --json "$PWD/${d::-1}.json"
done


