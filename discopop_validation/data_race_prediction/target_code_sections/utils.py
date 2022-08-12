from typing import List, Tuple

from discopop_validation.classes.Configuration import Configuration


def modify_tcs_according_to_inverse_line_mapping(target_code_sections: List[Tuple[str, str, str, str, str]],
                                                 run_configuration: Configuration) \
        -> List[Tuple[str, str, str, str, str]]:
    # tcs example: [(<section_id>, <file_id>, <target lines>, <var_name>, <suggestion_type>)]
    modified_list: List[Tuple[str, str, str, str, str]] = []

    # get inverted line mapping
    inverted_line_mapping = {v: k for k, v in run_configuration.line_mapping.items()}

    for tcs in target_code_sections:
        file_id = tcs[1]
        target_lines = [line for line in tcs[2].split(",") if len(line) > 0]
        modified_target_lines = []
        for line in target_lines:
            # apply inverted line mapping
            if str(file_id) + ":" + str(line) in inverted_line_mapping:
                modified_target_lines.append(inverted_line_mapping[str(file_id) + ":" + str(line)].split(":")[1])
            else:
                modified_target_lines.append(line)
        modified_target_lines_str = ""
        for l in modified_target_lines:
            modified_target_lines_str += str(l) + ","

        updated_tcs = (tcs[0], tcs[1], modified_target_lines_str, tcs[3], tcs[4])
        modified_list.append(updated_tcs)
    return modified_list

