# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import json
import os
from pathlib import Path
from posixpath import abspath, dirname
from typing import cast
from discopop_explorer.utilities.PEGraphConstruction.classes.DependenceItem import DependenceItem
from discopop_explorer.utilities.PEGraphConstruction.parser import __parse_dep_file
from discopop_library.DependencyComparator.DependencyComparatorArguments import DependencyComparatorArguments
from discopop_library.global_data.version.utils import get_version


def run(arguments: DependencyComparatorArguments) -> None:

    if not os.path.exists(arguments.gold_standard):
        raise FileNotFoundError(arguments.gold_standard)
    if not os.path.exists(arguments.test_set):
        raise FileNotFoundError(arguments.test_set)
    if arguments.output == "None" or arguments.output is None:
        raise ValueError("Argument output not specified.")

    if os.path.exists(arguments.output):
        os.remove(arguments.output)

    # read gold standard
    with open(arguments.gold_standard, "r") as f:
        parsed_gold_standard = __parse_dep_file(f, dirname(abspath(arguments.gold_standard)))[0]

    # read test_set
    with open(arguments.test_set, "r") as f:
        parsed_test_set = __parse_dep_file(f, dirname(abspath(arguments.test_set)))[0]

    overlap = []
    missing = []
    additional = []
    additional_init = []

    for dep in parsed_gold_standard:
        found = False
        for dep_2 in parsed_test_set:
            if dep_equal(dep, dep_2):
                overlap.append(dep)
                found = True
                break
        if found:
            continue
        missing.append(dep)

    for dep in parsed_test_set:
        found = False
        for dep_2 in parsed_gold_standard:
            if dep_equal(dep, dep_2):
                found = True
                break
        if found:
            continue
        if dep.type == "INIT":
            additional_init.append(dep)
        else:
            additional.append(dep)

    result_dir = {
        "overlap": len(overlap),
        "missing": len(missing),
        "additional_init": len(additional_init),
        "additional": len(additional),
    }

    print("ADDITIONAL: ")
    for add in additional:
        print("-> ", add)
    print()

    print("overlap: ", len(overlap))
    print("missing: ", len(missing))
    print("additional init: ", len(additional_init))
    print("additional: ", len(additional))

    with open(arguments.output, "w+") as f:
        json.dump(result_dir, f)


def dep_equal(a: DependenceItem, b: DependenceItem) -> bool:
    return cast(bool, a.sink == b.sink and a.source == b.source and a.type == b.type and a.var_name == b.var_name)
