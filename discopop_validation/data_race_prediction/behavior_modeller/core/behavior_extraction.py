import os
import shutil
from pathlib import Path
from typing import List, Tuple, Dict

from discopop_validation.data_race_prediction.target_code_sections.extraction import identify_target_sections_from_suggestions

try:
    from discopop_explorer import DetectionResult
except ModuleNotFoundError:
    from discopop_explorer import DetectionResult
from discopop_validation.data_race_prediction.behavior_modeller.classes.BBGraph import BBGraph
from discopop_validation.data_race_prediction.behavior_modeller.classes.BBNode import BBNode
from discopop_validation.data_race_prediction.behavior_modeller.classes.Operation import Operation


def execute_bb_graph_extraction(suggestions: Dict, file_mapping: str, ll_file_path: str, dp_build_path: str)\
        -> BBGraph:
    if os.path.exists("tmp_behavior_extraction"):
        shutil.rmtree("tmp_behavior_extraction")
    os.mkdir("tmp_behavior_extraction")
    os.chdir("tmp_behavior_extraction")
    # create file mapping dict
    file_mapping_dict: Dict[str, str] = {}
    with open(file_mapping, "r") as file_mapping_file:
        for line in file_mapping_file.readlines():
            split_line = line.split("\t")
            file_id = split_line[0]
            file_path = split_line[1].replace("\n", "")
            file_mapping_dict[file_id] = file_path
    # create input file for behavior extraction
    relevant_sections = identify_target_sections_from_suggestions(suggestions)
    with open("input.txt", "w+") as input_file:
        for section_id, start_line, end_line, var_name, cu_id, suggestion_type in relevant_sections:
            # replace file ids with path
            file_path = file_mapping_dict[start_line.split(":")[0]]
            file_id = start_line.split(":")[0]
            start_line = start_line.split(":")[1]
            end_line = end_line.split(":")[1]
            input_file.write(file_path + ";" + file_id + ";" + section_id + ";" + start_line + ";" + end_line + ";" + var_name + ";" + cu_id + ";" + suggestion_type + ";\n")
    # create output file for behavior extraction
    open("output.txt", "a+").close()
    # execute behavior extraction
    # todo account for different build paths
    # todo account for different opt installations
    if not dp_build_path.endswith("/"):
        dp_build_path += "/"
    opt_executable = "opt-8"
    behavior_extraction_so = os.path.join(dp_build_path, "libi/ValidationBehaviorExtraction.so")
    input_file_path = os.path.join(os.getcwd(), "input.txt")
    output_file_path = os.path.join(os.getcwd(), "output.txt")

    command = opt_executable + " < " + ll_file_path + " -load " + behavior_extraction_so + " -BehaviorExtraction" + \
              " -inputFile " + input_file_path + " -outputFile " + output_file_path
    os.system(command)
    os.chdir("../../..")

    # construct BBGraph
    bb_graph: BBGraph = BBGraph(output_file_path)
    # todo compression currently not correct!
    # bb_graph.compress()
    # cleanup
    # todo re-enable
    #shutil.rmtree("tmp_behavior_extraction")

    return bb_graph


