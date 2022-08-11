import os
import re
import subprocess
from os.path import dirname
from typing import Dict

from discopop_validation.classes.Configuration import Configuration
from discopop_validation.source_code_modifications.CodeDifferences import get_line_mapping_and_necessity_for_profiling


def handle_source_code_modifications(run_configuration: Configuration):
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

        # apply complete line mapping to profiling data
        __apply_line_mapping_to_profiling_data(run_configuration, complete_line_mapping)

    import sys
    sys.exit(0)


def __apply_line_mapping_to_profiling_data(run_configuration: Configuration, line_mapping: Dict[str, str]):
    print()
    print("Line mapping:")
    print(line_mapping)
    # apply to Data.xml
    __apply_line_mapping_to_cu_xml(run_configuration, line_mapping)
    # apply to loop_counter_output.txt
    __apply_line_mapping_to_loop_counter_file(run_configuration, line_mapping)
    # apply to out_dep.txt
    __apply_line_mapping_to_dependences_file(run_configuration, line_mapping)
    # apply to reduction.txt
    __apply_line_mapping_to_reduction_txt(run_configuration, line_mapping)
    pass


def __apply_line_mapping_to_cu_xml(run_configuration: Configuration, line_mapping: Dict[str, str]):
    with open(run_configuration.cu_xml + ".modified", "w+") as output:
        with open(run_configuration.cu_xml, "r") as input:
            for line in input.readlines():
                replaced_buffer = []
                for key in line_mapping:
                    # "Line" prior to occurence and not "occurence</nodeCalled>"
                    if "Line" not in line:
                        continue
                    line_index = line.index("Line")
                    if key not in line:
                        continue
                    key_indices = [m.start() for m in re.finditer(key, line)]
                    # "Line" has to occur prior to key
                    for key_index in key_indices:
                        if key_index in replaced_buffer:
                            continue
                        if line_index > key_index:
                            continue
                        # occurence may not be "occurence</nodeCalled>"
                        if key + "</nodeCalled>" in line:
                            tmp_idx = line.index(key + "</nodeCalled>")
                            if tmp_idx == key_index:
                                continue
                        # proper occurence
                        # replace occurence
                        line = line[:key_index] + line_mapping[key] + line[key_index + len(key):]
                        replaced_buffer.append(key_index)
                output.write(line)

    # use modified cu xml file
    run_configuration.cu_xml = run_configuration.cu_xml + ".modified"


def __apply_line_mapping_to_loop_counter_file(run_configuration: Configuration, line_mapping: Dict[str, str]):
    with open(run_configuration.loop_counter_file + ".modified", "w+") as output:
        with open(run_configuration.loop_counter_file, "r") as input:
            for line in input.readlines():
                split_line = line.split(" ")
                replaced_buffer = []
                for key in line_mapping:
                    file_id = key.split(":")[0]
                    line_num = key.split(":")[1]
                    if file_id != split_line[0]:
                        continue
                    if line_num == split_line[1] and line_num not in replaced_buffer:
                        mapped_line = line_mapping[key].split(":")[1]
                        split_line[1] = mapped_line
                        replaced_buffer.append(mapped_line)
                output.write(" ".join(split_line))
    # use modified loop counter file
    run_configuration.loop_counter_file = run_configuration.loop_counter_file + ".modified"


def __apply_line_mapping_to_dependences_file(run_configuration: Configuration, line_mapping: Dict[str, str]):
    with open(run_configuration.dep_file + ".modified", "w+") as output:
        with open(run_configuration.dep_file, "r") as input:
            for line in input.readlines():
                replaced_buffer = []
                for key in line_mapping:
                    if key in line and key not in replaced_buffer:
                        line = line.replace(key, line_mapping[key])
                        replaced_buffer.append(line_mapping[key])

                output.write(line)
    # use modified dependency file
    run_configuration.dep_file = run_configuration.dep_file + ".modified"


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
        line_mapping, profiling_necessity = get_line_mapping_and_necessity_for_profiling(file_path_last_profiled,
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