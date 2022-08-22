import os
import re
import subprocess
from os.path import dirname
from typing import Dict, Optional

from discopop_explorer import PETGraphX
from discopop_validation.classes.Configuration import Configuration
from discopop_validation.source_code_modifications.CodeDifferences import file_difference_checker


def handle_source_code_modifications(pet: PETGraphX, run_configuration: Configuration) -> PETGraphX:
    with open(run_configuration.file_mapping, "r") as fmap:
        complete_line_mapping: Dict[str, str] = dict()  # maps file_id:line to updated file_id:line
        for line in fmap:
            line = line.replace("\n", "")
            split_line = line.split("\t")
            file_id = split_line[0]
            file_path = split_line[1]
            file_path_last_profiled = file_path + ".last_profiled"

            line_mapping = __execute_profiling_if_necessary(run_configuration, file_path, file_path_last_profiled)
            # store results of line_mapping in complete_line_mapping
            for key in line_mapping:
                complete_line_mapping[str(file_id) + ":" + str(key)] = str(file_id) + ":" + str(line_mapping[key])

        # save line_mapping in run_configuration
        run_configuration.save_line_mapping(complete_line_mapping)
        # apply complete line mapping to pet graph
        pet = __apply_line_mapping_to_pet(pet, complete_line_mapping)
        # apply complete line mapping to reduction data
        __apply_line_mapping_to_profiling_data(run_configuration, line_mapping)

    return pet


def __apply_line_mapping_to_pet(pet: PETGraphX, line_mapping: Dict[str, str]) -> PETGraphX:
    for node in pet.all_nodes():
        # check start line
        start_line_str = "" + str(node.file_id) + ":" + str(node.start_line)
        if start_line_str in line_mapping:
            node.start_line = int(line_mapping[start_line_str].split(":")[1])
        # check end line
        end_line_str = "" + str(node.file_id) + ":" + str(node.end_line)
        if end_line_str in line_mapping:
            node.end_line = int(line_mapping[end_line_str].split(":")[1])
    return pet


def __apply_line_mapping_to_profiling_data(run_configuration: Configuration, line_mapping: Dict[str, str]):
    # apply to reduction.txt
    __apply_line_mapping_to_reduction_txt(run_configuration, line_mapping)


def __apply_line_mapping_to_reduction_txt(run_configuration: Configuration, line_mapping: Dict[str, str]):
    " FileID : 1 Loop Line Number : 66 Reduction Line Number : 70 Variable Name : sum Operation Name : +"
    if os.path.exists(run_configuration.reduction_file + ".modified"):
        os.remove(run_configuration.reduction_file + ".modified")
    with open(run_configuration.reduction_file + ".modified", "w+") as output:
        with open(run_configuration.reduction_file, "r") as input:
            for line in input.readlines():
                line = line.replace("\n", "")
                split_line = line.split(" ")
                replaced_buffer = []
                for key in line_mapping:
                    file_id = key.split(":")[0]
                    line_num = key.split(":")[1]
                    # check file id
                    if split_line[3] != file_id:
                        continue
                    # check and replace line number
                    if line_num in replaced_buffer:
                        continue
                    indices = [i for i, x in enumerate(split_line) if x == line_num]
                    mapped_line = line_mapping[key].split(":")[1]
                    for index in indices:
                        split_line[index] = mapped_line
                        replaced_buffer.append(mapped_line)
                output.write(" ".join(split_line) + "\n")
    # use modified reduction file
    run_configuration.reduction_file = run_configuration.reduction_file + ".modified"


def __execute_profiling_if_necessary(run_configuration: Configuration, file_path: str, file_path_last_profiled: str) -> Dict[int, int]:
    profiling_necessity = True
    line_mapping = dict()
    if os.path.exists(file_path_last_profiled):
        # get file difference and necessity for execution of profiling
        line_mapping, profiling_necessity = file_difference_checker(file_path_last_profiled,
                                                                    file_path)

    if profiling_necessity:
        print("PROFILING REQUIRED...")
        if run_configuration.dp_profiling_executable == "None":
            raise ValueError(
                "Profiling required. Please either:\n\t- execute profiling manually and restart the application, or\n\t- set the --dp-profiling-executable flag.")

        original_dir = os.getcwd()
        parent_dir = dirname(run_configuration.dp_profiling_executable)
        # change into directory
        os.chdir(parent_dir)
        # run discopop profiling
        subprocess.call(["sh", run_configuration.dp_profiling_executable])
        # change back to original dir
        os.chdir(original_dir)
        print("\nFINISHED profiling.")
    else:
        print("No profiling required.")

    return line_mapping