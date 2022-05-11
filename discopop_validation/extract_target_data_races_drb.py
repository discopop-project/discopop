import os
import re

def main():
    target_path = "test/code_samples/drb"
    for subdir, dirs, files in os.walk(target_path):
        for file in files:
            if file.endswith(".c") or file.endswith(".cpp"):
                file_path = os.path.join(subdir, file)
                # extract data races
                target_data_races = []
                with open(file_path, "r") as f:
                    for line in f.readlines():
                        reg_ex = r"\S+@\d+:\d+:[WR]\s+vs\.\s+\S+@\d+:\d+:[WR]"
                        found = re.findall(reg_ex, line)
                        target_data_races += found

                # extract lines from target_data_races
                tdr_lines = []
                var_names = []
                for tdr_pair in target_data_races:
                    tdr_pair = tdr_pair.replace(" ", "")
                    split_tdr = tdr_pair.split("vs.")
                    for single_tdr in split_tdr:
                        split_single_tdr = single_tdr.split("@")
                        var = split_single_tdr[0]
                        location_and_mode = split_single_tdr[1].split(":")
                        line = location_and_mode[0]
                        column = location_and_mode[1]
                        mode = location_and_mode[2]
                        tdr_lines.append(line)
                        var_names.append(var)
                tdr_lines = list(dict.fromkeys(tdr_lines))

                # output data races to target_data_races.txt
                output_file = os.path.join(subdir, "target_data_races.txt")
                if len(tdr_lines) > 0:
                    print("-->", output_file)
                    with open(output_file , "w+") as f:
                        for line_number in tdr_lines:
                            print("\t", line_number)
                            f.write(line_number + "\n")

                # output variable names to target_variable_names.txt
                output_file = os.path.join(subdir, "target_variable_names.txt")
                if len(var_names) > 0:
                    with open(output_file, "w+") as f:
                        for var_name in var_names:
                            f.write(var_name + "\n")


if __name__ == "__main__":
    main()