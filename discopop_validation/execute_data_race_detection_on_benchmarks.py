import os
import subprocess

def main():
    target_path = "test/code_samples/drb"
    original_dir = os.getcwd()
    benchmark_numbers = []
    for subdir, dirs, files in os.walk(target_path):
        # change into directory
        os.chdir( os.path.join(original_dir, subdir))

        # collect id's of benchmarks to be executed
        if "run_dp_maker.sh" in files:
            current_benchmark_number = os.path.basename(subdir)
            benchmark_numbers.append(current_benchmark_number)
        # change back to original dir
        os.chdir(original_dir)

    print("BENCHMARKS: ", benchmark_numbers)
    # execute data race detection on collected benchmarks
    for benchmark_number in benchmark_numbers:
        subprocess.call(["sh", "./run_drb.sh", benchmark_number])


if __name__ == "__main__":
    main()