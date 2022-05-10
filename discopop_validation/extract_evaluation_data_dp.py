import os
import subprocess

def main():
    target_path = "test/code_samples/discopop"
    original_dir = os.getcwd()
    benchmark_numbers_and_paths = []
    for subdir, dirs, files in os.walk(target_path):
        # change into directory
        os.chdir( os.path.join(original_dir, subdir))
        # collect id's of benchmarks
        if "run_dp_maker.sh" in files:
            current_benchmark_number = os.path.basename(subdir)
            benchmark_numbers_and_paths.append((current_benchmark_number, os.path.join(original_dir, subdir)))
        # change back to original dir
        os.chdir(original_dir)

    evaluation_results = dict()
    for benchmark_number, benchmark_path in benchmark_numbers_and_paths:

        is_supported_by_discopop = 0
        # if original_suggestions.json has been created, set to 1
        if os.path.exists(os.path.join(benchmark_path, "original_suggestions.json")):
            is_supported_by_discopop = 1

        is_supported_by_tool = 0
        # if data_races.txt has been created, set to 1
        if os.path.exists(os.path.join(benchmark_path, "data_races.txt")):
            is_supported_by_tool = 1

        # read identified data races
        identified_data_races = []
        if os.path.exists(os.path.join(benchmark_path, "data_races.txt")):
            with open(os.path.join(benchmark_path, "data_races.txt"), "r") as f:
                for line in f.readlines():
                    line = line.replace("\n", "")
                    identified_data_races.append(line)

        evaluation_results[benchmark_number] = (is_supported_by_discopop, is_supported_by_tool, len(identified_data_races), identified_data_races)

    print(evaluation_results)

    # write evaluation results to evaluation_results.csv
    with open("evaluation_results_dp.csv", "w+") as f:
        f.write("Benchmark;Is supported by DiscoPoP;Is supported by our tool;Identified data race lines;Data race lines\n")
        sorted_keys = list(evaluation_results.keys())
        sorted_keys.sort()
        for benchmark_number in sorted_keys:
            is_supported_by_discopop, is_supported_by_tool, data_race_count, identified_data_races = evaluation_results[benchmark_number]
            corrected_benchmark_number = str(benchmark_number)
            while len(corrected_benchmark_number) < 3:
                corrected_benchmark_number = "0" + corrected_benchmark_number

            f.write(str(corrected_benchmark_number)+";")
            f.write(str(is_supported_by_discopop) + ";")
            f.write(str(is_supported_by_tool)+";")
            f.write(str(data_race_count) + ";")
            for dr_line in identified_data_races:
                f.write(str(dr_line)+";")
            f.write("\n")


if __name__ == "__main__":
    main()