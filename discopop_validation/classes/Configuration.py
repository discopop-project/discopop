class Configuration(object):
    def __init__(self, path, cu_xml, dep_file, loop_counter_file, reduction_file, json_file, file_mapping,
                 ll_file, verbose_mode, data_race_output_path, dp_build_path, validation_time_limit, thread_count,
                 dp_profiling_executable, arguments):
        self.path = path
        self.cu_xml = cu_xml
        self.dep_file = dep_file
        self.loop_counter_file = loop_counter_file
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
