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
            if os.path.exists(os.path.join(os.path.join(original_dir, subdir), "data_races.txt")):
                # remove old identified data races
                os.remove(os.path.join(os.path.join(original_dir, subdir), "data_races.txt"))
        # change back to original dir
        os.chdir(original_dir)

    print("BENCHMARKS: ", benchmark_numbers)
    # execute data race detection on collected benchmarks
    for benchmark_number in benchmark_numbers:
        try:
            subprocess.call(["sh", "./run_drb.sh", benchmark_number], timeout=60)
        except subprocess.TimeoutExpired:
            print("TIMEOUT EXPIRED")
            continue


if __name__ == "__main__":
    main()