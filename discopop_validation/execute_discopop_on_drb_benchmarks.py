import os
import subprocess
from multiprocessing import Pool
from typing import Tuple, List


def __execute_process(command_tuple: Tuple[str, str, List[str]]):
    os.chdir(command_tuple[1])
    subprocess.call(command_tuple[2])
    os.chdir(command_tuple[0])



def main():
    target_path = "test/code_samples/drb"
    original_dir = os.getcwd()
    subprocesses_to_call = []  # original_dir, work_dir, command
    for subdir, dirs, files in os.walk(target_path):
        # change into directory
        os.chdir( os.path.join(original_dir, subdir))
        # run discopop
        if "run_dp_maker.sh" in files:
            #subprocess.call(["sh", "./run_dp_maker.sh"])
            work_dir = os.path.join(original_dir, subdir)
            command = ["sh", "./run_dp_maker.sh"]
            subprocesses_to_call.append((original_dir, work_dir, command))
        # change back to original dir
        os.chdir(original_dir)
    for entry in subprocesses_to_call:
        print(entry)

    with Pool() as thread_pool:
        thread_pool.map(__execute_process, subprocesses_to_call)


if __name__ == "__main__":
    main()