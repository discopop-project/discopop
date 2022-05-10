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
            try:
                subprocess.call(["sh", "./create_suggestions.sh"], timeout=60)
            except subprocess.TimeoutExpired:
                print("TIMEOUT EXPIRED")
        # change back to original dir
        os.chdir(original_dir)


if __name__ == "__main__":
    main()