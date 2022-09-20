from typing import Dict


class Configuration(object):
    def __init__(self, path, reduction_file, json_file, file_mapping,
                 ll_file, verbose_mode, data_race_output_path, dp_build_path, validation_time_limit, thread_count,
                 dp_profiling_executable, pet_dump_file, cu_xml_file, dep_file, loop_counter_file,
                 target_profiling_not_allowed, arguments):
        self.path = path
        self.reduction_file = reduction_file
        self.json_file = json_file
        self.file_mapping = file_mapping
        self.ll_file = ll_file
        self.verbose_mode = verbose_mode
        self.data_race_ouput_path = data_race_output_path
        self.dp_build_path = dp_build_path
        self.validation_time_limit = validation_time_limit
        self.thread_count = thread_count
        self.arguments = arguments
        self.omp_pragmas_file = path + "/pragmas.omp"
        self.dp_profiling_executable = dp_profiling_executable
        self.line_mapping: Dict[str, str] = None
        self.pet_dump_file: str = pet_dump_file
        self.cu_xml = cu_xml_file
        self.dep_file = dep_file
        self.loop_counter_file = loop_counter_file
        self.target_profiling_not_allowed = target_profiling_not_allowed

    def save_line_mapping(self, line_mapping: Dict[str, str]):
        self.line_mapping = line_mapping