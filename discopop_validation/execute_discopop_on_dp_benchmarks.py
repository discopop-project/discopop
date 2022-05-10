import os
import subprocess

def main():
    target_path = "test/code_samples/discopop"
    original_dir = os.getcwd()
    for subdir, dirs, files in os.walk(target_path):
        # change into directory
        os.chdir( os.path.join(original_dir, subdir))
        # run discopop
        if "run_dp_maker.sh" in files:
            subprocess.call(["sh", "./run_dp_maker.sh"])
        # change back to original dir
        os.chdir(original_dir)


if __name__ == "__main__":
    main()