# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
import os
import warnings
from discopop_explorer.aliases.LineID import LineID
from discopop_explorer.classes.PEGraph.Node import Node
from discopop_explorer.classes.PEGraph.PEGraphX import PEGraphX
from discopop_library.PathManagement.PathManagement import load_file_mapping
from discopop_library.Stubs.PerfoGraph.classes import PerfoGraphLoopTarget


def select_loop_target(pet: PEGraphX, loop_node: Node) -> PerfoGraphLoopTarget:
    warnings.warn("STUB PerfoGraph.loopTargetSelection.select_loop_target not implemented")
    # TODO: switch loop_position to loop text + Path to .discopop-folder to extract File paths from FileMapping.txt (20.02.)
    # TODO:  define + implement API for pre-trained model (@20.02 if possible)

    dp_path = pet.project_path
    file_id = loop_node.file_id
    start_line = loop_node.start_line
    end_line = loop_node.end_line
    with open(load_file_mapping(os.path.join(pet.project_path, "FileMapping.txt"))[file_id], "r") as f:
        lines = f.readlines()
        loop_lines = lines[start_line - 1 : end_line]
    source_code = "".join(loop_lines)

    print("CALL TO API: ")
    print("--> .discopop: ", dp_path)
    print("--> file_id: ", file_id)
    print("--> start_line: ", start_line)
    print("--> endl_line: ", end_line)
    print("--> source_code:")
    print(source_code)

    #    API:
    #    -> path to .discopop folder
    #    -> loop file id
    #    -> loop start line
    #    -> loop end line
    #    -> loop source code
    return PerfoGraphLoopTarget.OMP_FOR
