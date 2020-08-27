#!/bin/bash

ANALYZER='./../graph_analyzer/graph_analyzer.py'

for d in */ ; do
    basename $d
    python3 $ANALYZER --path "$PWD/$d/data" --json "$PWD/${d::-1}.json"
done


