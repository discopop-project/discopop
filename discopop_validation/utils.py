import json
import os

from typing import Dict, List

from discopop_explorer import NodeType
from discopop_explorer.utils import classify_loop_variables
from discopop_validation.classes.Configuration import Configuration
from discopop_validation.classes.OmpPragma import OmpPragma, PragmaType
from discopop_validation.data_race_prediction.utils import get_pet_node_id_from_source_code_lines
from discopop_validation.discopop_suggestion_interpreter.core import get_omp_pragmas_from_dp_suggestions


def __extract_data_sharing_clauses_from_pet(pet, omp_pragma_list):
    result_list = []
    for omp_pragmas in omp_pragma_list:
        pragma_to_cuid: Dict[OmpPragma, str] = dict()
        for pragma in omp_pragmas:
            cu_id = get_pet_node_id_from_source_code_lines(pet, pragma.file_id, pragma.start_line,
                                                           pragma.end_line)
            pragma_to_cuid[pragma] = cu_id

        print("####################################")
        print("PRAGMAS BEFORE ADDING FROM PET GRAPH")
        for pragma in omp_pragmas:
            print(pragma)
        print("####################################")

        for pragma in omp_pragmas:
            cu_id = pragma_to_cuid[pragma]
            if pet.node_at(cu_id).type == 2 and pragma.get_type() != PragmaType.PARALLEL:
                # node is loop type
                fpriv, priv, lpriv, shared, red = classify_loop_variables(pet, pet.node_at(cu_id))
                for var in shared:
                    if var.name not in pragma.get_variables_listed_as("shared"):
                        pragma.add_to_shared(var.name)
            #elif pragma.get_type() == PragmaType.TASK:
            #    fpriv, priv, shared, in_dep, out_dep, in_out_dep, red = classify_task_vars(pet, pet.node_at(cu_id), "", [], [])
            #    for var in shared:
            #        if var.name not in pragma.get_variables_listed_as("shared"):
            #            pragma.add_to_shared(var.name)
            elif pragma.get_type() == PragmaType.PARALLEL:
                # variables, which are declared outside the parallel region are shared
                # get a list of known variables and their definition lines from children nodes
                known_variables = []
                queue = [pet.node_at(cu_id)]
                visited = []
                while len(queue) > 0:
                    current = queue.pop(0)
                    visited.append(current)
                    for local_var in current.local_vars:
                        known_variables.append((local_var.name, local_var.defLine))
                    for global_var in current.global_vars:
                        known_variables.append((global_var.name, global_var.defLine))
                    known_variables = list(dict.fromkeys(known_variables))
                    for child in pet.direct_children(current):
                        if child not in visited:
                            queue.append(child)
                # mark those variables which are defined outside the parallel region as shared
                shared_defined_outside = []
                for name, raw_def_line in known_variables:
                    if raw_def_line == "LineNotFound":
                        continue
                    if ":" in raw_def_line:
                        split_raw_def_line = raw_def_line.split(":")
                        def_line_file_id = int(split_raw_def_line[0])
                        def_line = int(split_raw_def_line[1])
                        if def_line_file_id == pragma.file_id:
                            if not pragma.start_line <= def_line <= pragma.end_line:
                                shared_defined_outside.append(name)
                    elif raw_def_line == "GlobalVar":
                        shared_defined_outside.append(name)
                    else:
                        raise ValueError("Unhandled definition line: ", raw_def_line)

                # todo maybe remove, reason it is included: save drastic amounts of computation time
                # remove variable from shared_defined_outside, if it's a loop index
                loop_indices_to_remove = []
                loops_start_lines = []
                for v in pet.subtree_of_type(pet.node_at(pragma_to_cuid[pragma]), NodeType.LOOP):
                    loops_start_lines.append(v.start_position())
                for child in pet.direct_children(pet.node_at(pragma_to_cuid[pragma])):
                    for var_name in shared_defined_outside:
                        if var_name in loop_indices_to_remove:
                            continue
                        if pet.is_loop_index(var_name, loops_start_lines, pet.subtree_of_type(pet.node_at(pragma_to_cuid[pragma]), NodeType.CU)):
                            loop_indices_to_remove.append(var_name)
                shared_defined_outside = [var for var in shared_defined_outside if var not in loop_indices_to_remove]

                # add outside-defined variables to list of shared variables
                for var_name in shared_defined_outside:
                    if var_name not in pragma.get_variables_listed_as("shared"):
                        # check if var_name already use in another clause
                        if var_name not in pragma.get_known_variables():
                            if var_name is not None:
                                pragma.add_to_shared(var_name)


        print("PRAGMAS AFTER ADDING FROM PET GRAPH")
        for pragma in omp_pragmas:
            print(pragma)
        print("###################################")

        result_list.append(omp_pragmas)
    return result_list


def __preprocess_omp_pragmas(omp_pragma_list: List[List[OmpPragma]]):
    result = []
    for omp_pragmas in omp_pragma_list:
        inner_result = []
        for omp_pragma in omp_pragmas:
            # split parallel for pragma
            if omp_pragma.get_type() == PragmaType.PARALLEL_FOR:
                parallel_pragma = OmpPragma()
                parallel_pragma.file_id = omp_pragma.file_id
                parallel_pragma.start_line = omp_pragma.start_line
                omp_pragma.start_line = omp_pragma.start_line + 1
                parallel_pragma.end_line = omp_pragma.end_line
                first_privates = " ".join([var + "," for var in omp_pragma.get_variables_listed_as("first_private")])
                privates = " ".join([var + "," for var in omp_pragma.get_variables_listed_as("private")])
                last_privates = " ".join([var + "," for var in omp_pragma.get_variables_listed_as("last_private")])
                shared = " ".join([var + "," for var in omp_pragma.get_variables_listed_as("shared")])
                parallel_pragma.pragma = "parallel "
                parallel_pragma.pragma += "firstprivate(" + first_privates + ") "
                parallel_pragma.pragma += "private(" + privates + ") "
                parallel_pragma.pragma += "lastprivate(" + last_privates + ") "
                parallel_pragma.pragma += "shared(" + shared + ") "
                inner_result.append(parallel_pragma)
                omp_pragma.pragma = omp_pragma.pragma.replace("parallel ", "")
            inner_result.append(omp_pragma)
        result.append(inner_result)
    return result


def __get_omp_pragmas(run_configuration: Configuration):
    omp_pragma_list = []
    omp_pragmas = []
    # parse openmp pragmas file if parameter is set and file exists
    if os.path.isfile(run_configuration.omp_pragmas_file):
        with open(run_configuration.omp_pragmas_file) as f:
            for line in f.readlines():
                line = line.replace("\n", "")
                while line.startswith(" "):
                    line = line[1:]
                if line.startswith("//"):
                    # use // as comment marker
                    continue
                while "  " in line:
                    line = line.replace("  ", " ")
                omp_pragmas.append(OmpPragma().init_with_pragma_line(line))
    if len(omp_pragmas) > 0:
        omp_pragma_list.append(omp_pragmas)
    # interpret DiscoPoP suggestions if parameter is set and file exists
    if os.path.isfile(run_configuration.json_file):
        with open(run_configuration.json_file) as f:
            parallelization_suggestions = json.load(f)
            omp_pragma_list += get_omp_pragmas_from_dp_suggestions(parallelization_suggestions)
    return omp_pragma_list
