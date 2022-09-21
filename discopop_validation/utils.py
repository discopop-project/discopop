import json
import os

from typing import Dict, List, Tuple

from discopop_explorer import NodeType, PETGraphX
from discopop_explorer.utils import classify_loop_variables
from discopop_validation.classes.Configuration import Configuration
from discopop_validation.classes.OmpPragma import OmpPragma, PragmaType
from discopop_validation.data_race_prediction.utils import get_pet_node_id_from_source_code_lines
from discopop_validation.discopop_suggestion_interpreter.core import get_omp_pragmas_from_dp_suggestions
from discopop_validation.omp_pragma_extraction.core import create_pragmas_file


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
                        var.name = var.name + "%%implicit"
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
                        # todo might need a proper fix, such that less instances of LineNotFound occur
                        shared_defined_outside.append(name)
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
                shared_defined_outside = [var for var in shared_defined_outside if var not in loop_indices_to_remove and
                                          var is not None]

                # add outside-defined variables to list of shared variables
                for var_name in shared_defined_outside:
                    var_name_implicit = var_name + "%%implicit"
                    if var_name not in pragma.get_variables_listed_as("shared"):
                        # check if var_name already use in another clause
                        if var_name not in pragma.get_known_variables():
                            if var_name is not None:
                                pragma.add_to_shared(var_name_implicit)


        print("PRAGMAS AFTER ADDING FROM PET GRAPH")
        for pragma in omp_pragmas:
            print(pragma)
        print("###################################")
        print()

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
            # split TASKLOOP pragma into two TASK pragmas
            if omp_pragma.get_type() == PragmaType.TASKLOOP:
                task_pragma = OmpPragma()
                task_pragma.file_id = omp_pragma.file_id
                task_pragma.start_line = omp_pragma.start_line + 1
                omp_pragma.start_line = omp_pragma.start_line + 1
                task_pragma.end_line = omp_pragma.end_line
                first_privates = " ".join([var + "," for var in omp_pragma.get_variables_listed_as("first_private")])
                privates = " ".join([var + "," for var in omp_pragma.get_variables_listed_as("private")])
                last_privates = " ".join([var + "," for var in omp_pragma.get_variables_listed_as("last_private")])
                shared = " ".join([var + "," for var in omp_pragma.get_variables_listed_as("shared")])
                task_pragma.pragma = "task "
                task_pragma.pragma += "firstprivate(" + first_privates + ") "
                task_pragma.pragma += "private(" + privates + ") "
                task_pragma.pragma += "lastprivate(" + last_privates + ") "
                task_pragma.pragma += "shared(" + shared + ") "
                inner_result.append(task_pragma)
                omp_pragma.pragma = omp_pragma.pragma.replace("taskloop ", "task ").replace("taskloop", "task")
            inner_result.append(omp_pragma)
        result.append(inner_result)
    return result


def __get_omp_pragmas(run_configuration: Configuration, pet: PETGraphX):
    omp_pragma_list = []
    omp_pragmas = []
    if len(omp_pragmas) > 0:
        omp_pragma_list.append(omp_pragmas)
    # interpret DiscoPoP suggestions if parameter is set and file exists
    if os.path.isfile(run_configuration.json_file):
        with open(run_configuration.json_file) as f:
            parallelization_suggestions = json.load(f)
            omp_pragma_list += get_omp_pragmas_from_dp_suggestions(parallelization_suggestions)

    if run_configuration.only_supplied_suggestions != "True":
        omp_pragma_list += get_omp_pragmas_from_filemapping(run_configuration, pet)

    return omp_pragma_list


def get_omp_pragmas_from_filemapping(run_configuration: Configuration, pet: PETGraphX) -> [List[List[OmpPragma]]]:
    """Parse the files in filemapping and extract OpenMP pragmas from them"""
    omp_pragma_list: List[OmpPragma] = []
    with open(run_configuration.file_mapping, "r") as f:
        for line in f.readlines():
            line = line.replace("\n", "")
            split_line = line.split("\t")
            file_id = split_line[0]
            file_path = split_line[1]
            omp_pragma_list += __get_omp_pragmas_from_source_file(run_configuration, file_id, file_path, pet)
    return [omp_pragma_list]


def __get_omp_pragmas_from_source_file(run_configuration: Configuration, file_id: str, file_path, pet: PETGraphX) -> List[OmpPragma]:
    omp_pragma_list: List[OmpPragma] = []
    # get accurate pragma scopes
    scopes = __get_accurate_pragma_scopes(run_configuration, file_path)

    pragma_occurence_line_and_str_list = __get_pragma_strings_from_source_file(file_id, file_path)

    for occurence_line, pragma_str in pragma_occurence_line_and_str_list:
        if " " in pragma_str:
            directive = pragma_str.split(" ")[0]
        else:
            directive = pragma_str

        # find the best fitting scope
        best_fitting_scope = None
        best_distance = None
        for key in scopes:
            if directive in key:
                for potential_start, potential_end in scopes[key]:
                    if potential_start < occurence_line:
                        continue
                    if best_distance is None:
                        best_distance = potential_start - occurence_line
                        best_fitting_scope = (potential_start, potential_end)
                    else:
                        if potential_start - occurence_line < best_distance:
                            best_distance = potential_start - occurence_line
                            best_fitting_scope = (potential_start, potential_end)

        pragma_obj = OmpPragma()
        if best_fitting_scope is not None:
            pragma_obj.init_with_values(file_id, best_fitting_scope[0], best_fitting_scope[1], pragma_str)
        else:
            pragma_obj.init_with_values(file_id, occurence_line, occurence_line, pragma_str)
        omp_pragma_list.append(pragma_obj)
    return omp_pragma_list


def __get_accurate_pragma_scopes(run_configuration: Configuration, file_path: str) -> Dict[str, List[Tuple[int, int]]]:
    if os.path.exists(run_configuration.omp_pragmas_file):
        os.remove(run_configuration.omp_pragmas_file)
    create_pragmas_file(run_configuration)
    scopes = dict()
    with open(run_configuration.omp_pragmas_file) as f:
        for line in f:
            line = line.replace("\n", "")
            split_line = line.split(";")
            pragma = split_line[0].replace("OMP", "").replace("Directive", "").lower()
            pragma_file_path = split_line[1].split(":")[0]
            start_line = int(split_line[1].split(":")[1])
            end_line = int(split_line[2].split(":")[1])
            # only consider pragmas relevant for the given file_path
            if file_path == pragma_file_path:
                if pragma in scopes:
                    scopes[pragma].append((start_line, end_line))
                else:
                    scopes[pragma] = [(start_line, end_line)]
    return scopes



def __get_start_and_end_line_for_pragma(file_id: str, occurence_line, pet: PETGraphX):
    potential_target_nodes = [node for node in pet.all_nodes() if node.file_id == int(file_id) and node.start_line >= occurence_line]
    # sort nodes by their start line
    potential_target_nodes = sorted(potential_target_nodes, key=lambda x: x.start_line)
    # only consider such nodes with the lowest line number and thus the closest code location
    potential_target_nodes = [node for node in potential_target_nodes if node.start_line == potential_target_nodes[0].start_line]
    # sort potential_target_nodes by their end_lines
    potential_target_nodes = sorted(potential_target_nodes, key=lambda x: x.end_line)
    # the first entry is the closest and smallest fitting CU, and thus the best fit for the given pragma.
    parent_cu_node = potential_target_nodes[0]
    return parent_cu_node.start_line, parent_cu_node.end_line

    # old version
#    # sort and reverse potential_target_nodes by their end_lines
#    potential_target_nodes = sorted(potential_target_nodes, key=lambda x: x.end_line, reverse=True)
#    # the first entry is the closest and largest CU, and thus the best fit for the given pragma.
#    parent_cu_node = potential_target_nodes[0]



def __get_pragma_strings_from_source_file(file_id, file_path):
    pragma_occurence_line_and_str_list = []
    with open(file_path, "r") as source_file:
        continue_to_buffer = False
        buffer = ""
        buffer_line_id = 0
        for line_id, line in enumerate(source_file.readlines()):
            line = line.replace("\n", "")
            if "//" in line:
                line = line[:line.index("//")]
            if "#pragma omp " in line:
                buffer_line_id = line_id + 1
                line = line.replace("#pragma omp ", "")
                if line.endswith("\\"):
                    buffer += line[:-1]
                    continue_to_buffer = True
                    continue
                else:
                    buffer = line
                    buffer = buffer.replace("\t", " ").replace("  ", "")
                    while buffer.startswith(" "):
                        buffer = buffer[1:]
                    pragma_occurence_line_and_str_list.append((buffer_line_id, buffer))
                    buffer = ""
                    continue_to_buffer = False
                    continue
            if continue_to_buffer:
                if line.endswith("\\"):
                    print("L: ", line[:-1])
                    buffer += line[:-1]
                    continue
                else:
                    buffer += line
                    continue_to_buffer = False
                    buffer = buffer.replace("\t", " ").replace("  ", "")
                    while buffer.startswith(" "):
                        buffer = buffer[1:]
                    pragma_occurence_line_and_str_list.append((buffer_line_id, buffer))
                    buffer = ""
                    continue
    return pragma_occurence_line_and_str_list