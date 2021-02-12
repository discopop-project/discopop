import os
import pathlib
import re
import subprocess
import sys
from typing import Dict, List, Optional

from docopt import docopt
from lxml import objectify
from schema import Schema, Use, SchemaError

docopt_schema = Schema({
    '--fmap': Use(str),
    '--cu-xml': Use(str),
    '--output': Use(str),
})


def __get_alias_from_statement(var_name: str, var_type: str, statement: str) -> Optional[List[str]]:
    """checks if the given statement defines a new alias for var_name.
    returns a list containing the found alias name or None, if no alias has been defined by statement.
    :param var_name: target variable name
    :param var_type: type of the variable
    :param statement: statement to check for new alias definition
    :return: None, or list containing a found alias name."""
    # prune var_name
    if ".addr" in var_name:
        var_name = var_name.replace(".addr", "")
    # prune statement
    if ":" in statement:
        statement = statement[statement.rindex(":") + 1:]
    # var_name in statement?
    reg = r"\W" + re.escape(var_name) + r"\W"
    search_string = re.search(reg, statement)
    try:
        search_string = search_string[0]
    except TypeError:
        search_string = None
    if search_string is None:
        return None
    # operation is '=' ?
    stmt_copy = statement
    stmt_copy = stmt_copy.replace("<=>", "  ").replace("<<=", "   ").replace(">>=", "   ").replace("==", "  ")
    stmt_copy = stmt_copy.replace("!=", "  ").replace("+=", "  ").replace("-=", "  ").replace("*=", "  ")
    stmt_copy = stmt_copy.replace("/=", "  ").replace("%=", "  ").replace("<=", "  ").replace(">=", "  ")
    stmt_copy = stmt_copy.replace("&=", "  ").replace("^=", "  ").replace("|=", "  ")
    if "=" not in stmt_copy:
        return None
    # prune statement to single contained '='
    if stmt_copy.count("=") > 1:
        if stmt_copy.count(",") == 0:
            return None
        indices = [i for i, x in enumerate(stmt_copy) if x == ","]
        indices = indices + [len(stmt_copy)]
        aliases = []
        for idx, index in enumerate(indices):
            if idx == 0:
                stmt = statement[:indices[idx]]
            elif idx == len(indices) - 1:
                stmt = statement[indices[idx - 1] + 1:index + 1]
            else:
                stmt = statement[indices[idx - 1] + 1: indices[idx]]
            tmp = __get_alias_from_statement(var_name, var_type, stmt)
            if tmp is not None:
                aliases += tmp
        if len(aliases) == 0:
            return None
        return aliases

    # var_name on left hand side?
    if stmt_copy.index(var_name) < stmt_copy.index("="):
        return None
    # var_name contained in function call?
    left_hand_side = statement[:stmt_copy.index("=")]
    right_hand_side = statement[stmt_copy.index("=") + 1:]
    call_string = re.search(r"[\w]+(?=\().+\)", right_hand_side)
    try:
        call_string = call_string[0]
    except TypeError:
        call_string = None
    if call_string is not None:
        if var_name in call_string:
            return None
    # var_name is pointer type?
    if "*" in var_type:
        # left branch in diagram
        # var_name has index access?
        if right_hand_side.index(var_name) + len(var_name) < len(right_hand_side):
            if right_hand_side[right_hand_side.index(var_name) + len(var_name)] == "[":
                return None
        # '*' prior to var_name?
        if right_hand_side.index(var_name) - 1 >= 0:
            if right_hand_side[right_hand_side.index(var_name) - 1] == "*":
                return None
        # '*' and '(' prior, no ')' prior to var_name?
        if right_hand_side.index(var_name) - 2 >= 0:
            if right_hand_side[right_hand_side.index(var_name) - 2] == "*" and \
                    right_hand_side[right_hand_side.index(var_name) - 1] == "(":
                if ")" not in right_hand_side[
                              right_hand_side.index(var_name) - 2:right_hand_side.index(var_name) + len(var_name)]:
                    return None
        # '->' after var_name?
        if right_hand_side.index(var_name) + len(var_name) + 2 > len(right_hand_side):
            if right_hand_side[right_hand_side.index(var_name) + len(var_name): right_hand_side.index(var_name) + len(
                    var_name) + 1] == "->":
                return None
    else:
        # right branch in diagram
        # '&' prior to var_name?
        if right_hand_side.index(var_name) - 1 >= 0:
            if not right_hand_side[right_hand_side.index(var_name) - 1] == "&":
                return None
        # var_name has index access?
        if right_hand_side.index(var_name) + len(var_name) < len(right_hand_side):
            if right_hand_side[right_hand_side.index(var_name) + len(var_name)] == "[":
                return None
        # '*' prior to '&'?
        if right_hand_side.index(var_name) - 2 >= 0:
            if right_hand_side[right_hand_side.index(var_name) - 1] == "&" and \
                    right_hand_side[right_hand_side.index(var_name) - 2] == "*":
                return None
        # '*' and '(' prior, no ')' prior to '&'?
        if right_hand_side.index(var_name) - 2 >= 0:
            if right_hand_side[right_hand_side.index(var_name) - 2] == "*" and \
                    right_hand_side[right_hand_side.index(var_name) - 1] == "(":
                if ")" not in right_hand_side[
                              right_hand_side.index(var_name) - 2:right_hand_side.index(var_name)]:
                    return None
        # '->' after var_name?
        if right_hand_side.index(var_name) + len(var_name) + 2 > len(right_hand_side):
            if right_hand_side[right_hand_side.index(var_name) + len(var_name): right_hand_side.index(var_name) + len(
                    var_name) + 1] == "->":
                return None
    # left hand side is single token?
    left_hand_split = left_hand_side.split(" ")
    left_hand_split = [x for x in left_hand_split if len(x) > 0]
    if len(left_hand_split) == 1:
        return left_hand_split
    # only type and modifiers on left hand side?
    if len(left_hand_split) <= 4:
        return [left_hand_split[-1]]
    return None


def __add_alias_information(function_information_list: List[Dict], statements_file: str) -> List[Dict]:
    """Wrapper to gather and append alias information to the entries in function_information as a new field.
    Aliases can be found up to a depth of 2.
    Alias detection ignores scopes.
    Alias detection ignores a=b=c constellations.
    :param function_information_list: list of dictionaries representing the functions contained in cu-xml
    :param statements_file: path to file containing the output of getStatements
    :return: Input list of dictionaries, enriched with alias information."""
    result_list = []
    for function_information in function_information_list:
        file_id = function_information["id"].split(":")[0]
        body_start_line = function_information["startsAtLine"].split(":")[1]
        body_end_line = function_information["endsAtLine"].split(":")[1]
        # get such statements which occur inside current functions body
        relevant_statements = []
        with open(statements_file, "r") as sf:
            for line in sf.readlines():
                line_file_id = line[:line.index(":")]
                line_code_line = line[line.index(":") + 1:]
                line_code_line = line_code_line[: line_code_line.index(":")]
                if file_id != line_file_id:
                    continue
                if int(body_start_line) > int(line_code_line):
                    continue
                if int(body_end_line) < int(line_code_line):
                    continue
                line = line.replace("\n", "")
                # append line + line_code_line for sorting, removed afterwards
                relevant_statements.append((line, int(line_code_line)))
        # order relevant statements by line number
        relevant_statements.sort(key=lambda x: x[1])
        relevant_statements = [x[0] for x in relevant_statements]
        # get aliases for each argument
        function_information["aliases"] = []
        for arg_idx, arg_name in enumerate(function_information["args"]):
            aliases = []
            for statement in relevant_statements:
                # search for first-level aliases
                statement_result = __get_alias_from_statement(arg_name, function_information["arg_types"][arg_idx],
                                                              statement)
                if statement_result is not None:
                    for state_res_entry in statement_result:
                        # first level alias found
                        # search for second level aliases
                        for inner_statement in relevant_statements:
                            statement_line = statement[statement.index(":") + 1:]
                            statement_line = statement_line[: statement_line.index(":")]
                            inner_statement_line = inner_statement[inner_statement.index(":") + 1:]
                            inner_statement_line = inner_statement_line[: inner_statement_line.index(":")]
                            if int(inner_statement_line) < int(statement_line):
                                continue
                            inner_statement_result = __get_alias_from_statement(state_res_entry, "*", inner_statement)
                            if inner_statement_result is not None:
                                # second level alias found
                                aliases += inner_statement_result
                    aliases += statement_result
            aliases = list(set(aliases))
            function_information["aliases"].append(aliases)
        result_list.append(function_information)
    return result_list


def __get_function_information(cu_xml: str) -> List[Dict]:
    """Extracts information on functions from given cu_xml file and stores it in a dictionary representation.
    :param cu_xml: path to cu_xml file
    :return: List of dictionaries representing functions from cu_xml"""
    with open(cu_xml) as xml_fd:
        xml_content = ""
        for line in xml_fd.readlines():
            if not (line.rstrip().endswith('</Nodes>') or line.rstrip().endswith('<Nodes>')):
                xml_content = xml_content + line
    xml_content = "<Nodes>{0}</Nodes>".format(xml_content)
    parsed_cu = objectify.fromstring(xml_content)
    function_information = []
    for node in parsed_cu.Node:
        node.childrenNodes = str(node.childrenNodes).split(',') if node.childrenNodes else []
        if node.get('type') == '1':
            entry = dict()
            entry["name"] = node.get("name")
            entry["startsAtLine"] = node.get("startsAtLine")
            entry["endsAtLine"] = node.get("endsAtLine")
            entry["id"] = node.get("id")
            entry["args"] = []
            if hasattr(node, 'funcArguments') and hasattr(node.funcArguments, 'arg'):
                entry["args"] = [v.text for v in node.funcArguments.arg]
            entry["arg_types"] = []
            if hasattr(node, 'funcArguments') and hasattr(node.funcArguments, 'arg'):
                entry["arg_types"] = [v.get('type') for v in node.funcArguments.arg]
            function_information.append(entry)
    return function_information


def __create_statements_file(file_mapping: str, output_file: str, application_path: str):
    """Wrapper to start getStatements application for each source code file in file_mapping
    :param file_mapping: path to file_mapping file
    :param output_file: path to output file
    :param application_path: path to getStatements executable"""
    file_mapping_dict = dict()  # maps path to file-id
    with open(file_mapping) as fm:
        for line in fm.readlines():
            line = line.replace("\n", "")
            line = line.split("\t")
            file_mapping_dict[line[1]] = line[0]
    # execute application for each file in file_mapping
    for file in file_mapping_dict:
        process = subprocess.Popen(application_path + " " + file + " >> " + output_file, shell=True,
                                   stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        process.wait()
    # cleanup results and replace paths with file-ids
    if os.path.exists(output_file + "_tmp"):
        os.remove(output_file + "_tmp")
    with open(output_file + "_tmp", "w+") as tmp_of:
        with open(output_file, "r") as of:
            for line in of.readlines():
                line = line.replace("\n", "")
                if len(line) == 0:
                    continue
                left = line[:line.rfind(":")]
                right = line[line.rfind(":"):]
                left = re.sub(r"<.*>", "", left)
                file_path = left[:left.find(":")]
                left = left.replace(file_path, file_mapping_dict[file_path])
                line = left + right
                while " :" in line or ": " in line:
                    line = line.replace(" :", ":")
                    line = line.replace(": ", ":")
                if "=" not in line:
                    continue
                tmp_of.write(line + "\n")
    os.remove(output_file)
    os.rename(output_file + "_tmp", output_file)


def main():
    arguments = docopt(__doc__)

    try:
        arguments = docopt_schema.validate(arguments)
    except SchemaError as e:
        exit(e)

    file_mapping = arguments['--fmap']
    cu_xml = arguments['--cu-xml']
    output_file = arguments['--output']

    if not os.path.isfile(file_mapping):
        print(f"File not found: \"{file_mapping}\"")
        sys.exit()
    if not os.path.isfile(cu_xml):
        print(f"File not found: \"{cu_xml}\"")
        sys.exit()

    # build getStatements application
    original_cwd = os.getcwd()
    parent_dir = str(pathlib.Path(__file__).parent.absolute())
    if not os.path.exists(parent_dir + "/build"):
        os.mkdir(parent_dir + "/build")
    os.chdir(parent_dir + "/build")
    process = subprocess.Popen("cmake .. && make", shell=True, stdout=subprocess.PIPE)
    process.wait()
    os.chdir("..")
    # remove output file if it already exists
    if os.path.exists(output_file + "_statements"):
        os.remove(output_file + "_statements")
    if os.path.exists(output_file):
        os.remove(output_file)
    # create statements file
    __create_statements_file(file_mapping, output_file + "_statements", parent_dir + "/build/getStatements")
    # get function information file
    function_information = __get_function_information(cu_xml)
    # add alias information to function_information
    function_information = __add_alias_information(function_information, output_file + "_statements")
    # create alias output file
    with open(output_file, "w+") as of:
        for fn_info in function_information:
            if len(fn_info["args"]) == 0:
                continue
            for idx, alias_entry in enumerate(fn_info["aliases"]):
                if len(alias_entry) > 0:
                    for alias_name in alias_entry:
                        of.write(fn_info["id"] + ";" + fn_info["name"] + ";" + fn_info["args"][
                            idx] + ";" + alias_name + "\n")
    # cleanup
    if os.path.exists(output_file + "_statements"):
        os.remove(output_file + "_statements")
    # reset working directory
    os.chdir(original_cwd)


if __name__ == "__main__":
    main()
