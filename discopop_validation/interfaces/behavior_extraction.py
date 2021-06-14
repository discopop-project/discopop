import os
import shutil
from pathlib import Path
from typing import List, Tuple, Dict
from ...discopop_explorer import DetectionResult
from .BBGraph import BBGraph, BBNode


def get_relevant_sections_from_suggestions(suggestions: DetectionResult) -> List[Tuple[str, str, str, str]]:
    """extracts relevant sections in the original source code from the gathered suggestions and reports them in tuples.
    Output format: [(<section_id>, <start_line>, <end_line>, <var_name>)]
    TODO: For now, only Do-All pattern is reported!
    """
    interim_result: List[Tuple[str, str, str]] = []
    # include do-all suggestions
    for do_all_sug in suggestions.do_all:
        start_line = do_all_sug.start_line
        end_line = do_all_sug.end_line
        for var in do_all_sug.shared:
            interim_result.append((start_line, end_line, var.name))
    interim_result = list(set(interim_result))
    result: List[Tuple[str, str, str, str]] = []
    for idx, r in enumerate(interim_result):
        result.append((str(idx), r[0], r[1], r[2]))
    return result


def execute_behavior_extraction(suggestions: DetectionResult, file_mapping: str, ll_file_path: str)\
        -> Dict[int, List[List[List[BBNode]]]]:
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
    relevant_sections = get_relevant_sections_from_suggestions(suggestions)
    with open("input.txt", "w+") as input_file:
        for section_id, start_line, end_line, var_name in relevant_sections:
            # replace file ids with path
            file_path = file_mapping_dict[start_line.split(":")[0]]
            start_line = start_line.split(":")[1]
            end_line = end_line.split(":")[1]
            input_file.write(file_path + ";" + section_id + ";" + start_line + ";" + end_line + ";" + var_name + ";\n")
    # create output file for behavior extraction
    open("output.txt", "a+").close()
    # execute behavior extraction
    # todo account for different build paths
    # todo account for different opt installations
    build_path = os.path.join(str(Path(__file__).resolve().parent.parent.parent), "build/")
    opt_executable = "opt-8"
    behavior_extraction_so = os.path.join(build_path, "libi/ValidationBehaviorExtraction.so")
    input_file_path = os.path.join(os.getcwd(), "input.txt")
    output_file_path = os.path.join(os.getcwd(), "output.txt")

    command = opt_executable + " < " + ll_file_path + " -load " + behavior_extraction_so + " -BehaviorExtraction" + \
              " -inputFile " + input_file_path + " -outputFile " + output_file_path
    os.system(command)
    os.chdir("..")

    # construct BBGraph
    bb_graph: BBGraph = BBGraph(output_file_path)
    bb_graph.compress()
    # bb_graph.show()
    path_combinations_dict = bb_graph.get_possible_path_combinations_for_sections()

    # todo enable clean-up
    # shutil.rmtree("tmp_behavior_extraction")

    return path_combinations_dict
