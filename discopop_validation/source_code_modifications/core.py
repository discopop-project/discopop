import os
import subprocess
from os.path import dirname

from discopop_validation.classes.Configuration import Configuration
from discopop_validation.source_code_modifications.CodeDifferences import get_line_mapping_and_necessity_for_profiling


def handle_source_code_modifications(run_configuration: Configuration):
    with open(run_configuration.file_mapping, "r") as fmap:
        for line in fmap:
            line = line.replace("\n", "")
            split_line = line.split("\t")
            file_id = split_line[0]
            file_path = split_line[1]
            file_path_last_profiled = file_path + ".last_profiled"

            profiling_necessity = True
            if os.path.exists(file_path_last_profiled):
                # get file difference and necessity for execution of profiling
                line_mapping, profiling_necessity = get_line_mapping_and_necessity_for_profiling(file_path_last_profiled, file_path)

            if profiling_necessity:
                print("PROFILING REQUIRED...")
                if run_configuration.dp_profiling_executable == "None":
                    raise ValueError("Profiling required. Please either:\n\t- execute profiling manually and restart the application, or\n\t- set the --dp-profiling-executable flag.")

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


    import sys
    sys.exit(0)