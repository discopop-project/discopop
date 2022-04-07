import os
import subprocess

def main():
    target_path = "test/code_samples/drb"
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
        is_supported_by_tool = 0
        # if data_races.txt has been created, set to 1
        if os.path.exists(os.path.join(benchmark_path, "data_races.txt")):
            is_supported_by_tool = 1

        # read target data races
        target_data_races = []
        if os.path.exists(os.path.join(benchmark_path, "target_data_races.txt")):
            with open(os.path.join(benchmark_path, "target_data_races.txt"), "r") as f:
                for line in f.readlines():
                    line = line.replace("\n", "")
                    target_data_races.append(line)

        benchmark_contains_data_races = len(target_data_races)

        data_races_in_arrays = 0
        if os.path.exists(os.path.join(benchmark_path, "target_variable_names.txt")):
            with open(os.path.join(benchmark_path, "target_variable_names.txt")) as f:
                for line in f.readlines():
                    if "[" in line and "]" in line:
                        data_races_in_arrays = 1

        # read identified data races
        identified_data_races = []
        if os.path.exists(os.path.join(benchmark_path, "data_races.txt")):
            with open(os.path.join(benchmark_path, "data_races.txt"), "r") as f:
                for line in f.readlines():
                    line = line.replace("\n", "")
                    identified_data_races.append(line)

        # check for evaluation values
        correct_data_races_identified = 0
        if set(target_data_races) == set(identified_data_races):
            correct_data_races_identified = 1

        some_correct_data_races_identified = 0
        if len([dr for dr in identified_data_races if dr in target_data_races]) > 0:
            some_correct_data_races_identified = 1
        # correct some_corrected_data_races_identified in case that target_data_races is empty
        if some_correct_data_races_identified == 0 and correct_data_races_identified == 1:
            some_correct_data_races_identified = 1

        additional_data_races_identified = 0
        if len([dr for dr in identified_data_races if dr not in target_data_races]) > 0:
            additional_data_races_identified = 1

        evaluation_results[benchmark_number] = (is_supported_by_tool, benchmark_contains_data_races, data_races_in_arrays, correct_data_races_identified,
                                                some_correct_data_races_identified, additional_data_races_identified)

    print(evaluation_results)

    # write evaluation results to evaluation_results.csv
    with open("evaluation_results.csv", "w+") as f:
        f.write("Benchmark;Is supported by our tool;Benchmark contains data races;Data races on array type;Correct data races identified;Some correct data races identified;Additional data races reported\n")
        sorted_keys = list(evaluation_results.keys())
        sorted_keys.sort()
        for benchmark_number in sorted_keys:
            is_supported_by_tool, benchmark_contains_data_races, data_races_in_arrays, correct_data_races_identified, some_correct_data_races_identified, additional_data_races_identified = evaluation_results[benchmark_number]
            corrected_benchmark_number = str(benchmark_number)
            while len(corrected_benchmark_number) < 3:
                corrected_benchmark_number = "0" + corrected_benchmark_number

            f.write(str(corrected_benchmark_number)+";")
            f.write(str(is_supported_by_tool)+";")
            f.write(str(benchmark_contains_data_races)+";")
            f.write(str(data_races_in_arrays) + ";")
            f.write(str(correct_data_races_identified)+";")
            f.write(str(some_correct_data_races_identified)+";")
            f.write(str(additional_data_races_identified)+";"+"\n")










if __name__ == "__main__":
    main()