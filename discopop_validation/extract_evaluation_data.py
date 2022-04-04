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

        # read identified data races
        identified_data_races = []
        if os.path.exists(os.path.join(benchmark_path, "data_races.txt")):
            with open(os.path.join(benchmark_path, "data_races.txt"), "r") as f:
                for line in f.readlines():
                    line = line.replace("\n", "")
                    identified_data_races.append(line)

        # check for evaluation values
        correct_data_races_identified = 0
        if target_data_races == identified_data_races:
            correct_data_races_identified = 1

        some_correct_data_races_identified = 0
        if len([dr for dr in identified_data_races if dr in target_data_races]) > 0:
            some_correct_data_races_identified = 1

        additional_data_races_identified = 0
        if len([dr for dr in identified_data_races if dr not in target_data_races]) > 0:
            additional_data_races_identified = 1

        evaluation_results[benchmark_number] = (is_supported_by_tool, correct_data_races_identified,
                                                some_correct_data_races_identified, additional_data_races_identified)

    print(evaluation_results)

    # write evaluation results to evaluation_results.csv
    with open("evaluation_results.csv", "w+") as f:
        f.write("Benchmark;Is supported by our tool;Correct data races identified;Some correct data races identified;Additional data races reported\n")
        sorted_keys = list(evaluation_results.keys())
        sorted_keys.sort()
        for benchmark_number in sorted_keys:
            is_supported_by_tool, correct_data_races_identified, some_correct_data_races_identified, additional_data_races_identified = evaluation_results[benchmark_number]
            f.write(str(benchmark_number)+";")
            f.write(str(is_supported_by_tool)+";")
            f.write(str(correct_data_races_identified)+";")
            f.write(str(some_correct_data_races_identified)+";")
            f.write(str(additional_data_races_identified)+";"+"\n")










if __name__ == "__main__":
    main()