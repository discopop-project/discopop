import subprocess

from discopop_validation.classes.Configuration import Configuration


def create_pragmas_file(run_config: Configuration):
    """Wrapper to start getOmpPragmas application for each source code file in file_mapping
    """
    file_mapping_dict = dict()  # maps path to file-id
    with open(run_config.file_mapping) as fm:
        for line in fm.readlines():
            line = line.replace("\n", "")
            split_line = line.split("\t")
            file_mapping_dict[split_line[1]] = split_line[0]
    # get application path
    application_path = run_config.dp_build_path + "rtlib/omp-pragma-extraction/getOmpPragmas"

    # execute application for each file in file_mapping
    for file in file_mapping_dict:
        process = subprocess.Popen(application_path + " " + file + " --extra-arg='-fopenmp'  >> " + run_config.omp_pragmas_file, shell=True,
                                   stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        process.wait()