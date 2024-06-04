from argparse import ArgumentParser
from dataclasses import dataclass
import logging
import os
from typing import Dict, List

from discopop_library.ArgumentClasses.GeneralArguments import GeneralArguments
from discopop_library.GlobalLogger.setup import setup_logger

logger = logging.getLogger("PerfoGraphCompatProvider")

@dataclass
class PerfoGraphCompatibilityArguments(GeneralArguments):
    """Container Class for the arguments passed to the perfograph compatibility tool"""

    llvm_ir_file: str
    dynamic_deps_file: str
    output_file: str
    force_output: bool

    def __post_init__(self):
        self.__validate()

    def __validate(self):
        """Validate the arguments passed to the discopop_explorer, e.g check if given files exist"""
        pass
        # check if input files exist
        if not os.path.exists(self.llvm_ir_file):
            raise FileNotFoundError(self.llvm_ir_file)
        if not os.path.exists(self.dynamic_deps_file):
            raise FileNotFoundError(self.dynamic_deps_file)
        # raise warning if output file exists already
        if os.path.exists(self.output_file):
            if self.force_output:
                pass
            else:
                raise FileExistsError(self.output_file)
        pass


def parse_args() -> PerfoGraphCompatibilityArguments:
    """Parse the arguments passed to the discopop_explorer"""
    parser = ArgumentParser(description="DiscoPoP PerfoGraph compatibility tool")

    # fmt: off
    parser.add_argument("-ir", "--llvm-ir", type=str, help="path to llvm_ir file created by DiscoPoP", default="")
    parser.add_argument("-dep", "--dynamic-deps", type=str, help="path to the dynamic_dependencies.txt file created by DiscoPoP", default="")
    parser.add_argument("-o", "--output", type=str, help="output path for the modified dynamic dependencies file", default="")
    parser.add_argument("-f", "--force-output",  action="store_true", help="overwrite the output file if already existing")
    parser.add_argument("--log", type=str, default="WARNING", help="Specify log level: DEBUG, INFO, WARNING, ERROR, CRITICAL")
    parser.add_argument("--write-log", action="store_true", help="Create Logfile.")

    # fmt: on

    arguments = parser.parse_args()

    return PerfoGraphCompatibilityArguments(
        llvm_ir_file=arguments.llvm_ir,
        dynamic_deps_file=arguments.dynamic_deps,
        output_file=arguments.output,
        force_output=arguments.force_output,
        log_level=arguments.log.upper(),
        write_log=arguments.write_log,
    )

def main():
    arguments = parse_args()
    setup_logger(arguments)
    run(arguments)

def run(arguments: PerfoGraphCompatibilityArguments):
    
    logger.info("Configuration:")
    logger.info("\tLLVMIR: " + arguments.llvm_ir_file)
    logger.info("\tDYNDEP: " + arguments.dynamic_deps_file)
    logger.info("\tOUTPUT: " + arguments.output_file)
    logger.info("\tforce : " + str(arguments.force_output))

    instruction_id_to_md_tag_dict = __get_instruction_id_to_md_tag_dict(arguments)
    raw_dynamic_dependencies = __update_dynamic_dependencies(arguments, instruction_id_to_md_tag_dict)

def __update_dynamic_dependencies(arguments: PerfoGraphCompatibilityArguments, instruction_id_to_md_tag_dict: Dict[str, str]) -> List[List[str]]:
    """read dynamic dependencies file line by line, split its contents for further processing,
    replace instruction ids with metadata tags, and output to file"""
    sublogger = logger.getChild("__get_raw_dynamic_dependencies")
    raw_dynamic_dependencies: List[List[str]] = []
    
    with open(arguments.output_file, "w+") as of:
        with open(arguments.dynamic_deps_file, "r") as f:
            for line in f.readlines():
                line = line.replace("\n", "")
                sublogger.debug("line: "+ line)
                split_line = line.split(" ")
                # update the line according to instruction_md_tag_to_id_dict
                updated_line = ""
                for idx, substr in enumerate(split_line):
                    # identify candidates for substitution
                    if ":" in substr:
                        continue
                    if substr in ["NOM", "INIT", "END", "BGN", "START"]:
                        continue
                    if substr.startswith("WAR") or substr.startswith("RAW") or substr.startswith("WAW"):
                        continue
                    if len(substr) == 0:
                        continue
                    
                    # substitute instruction ids with metadata tags
                    if not "|" in substr:
                        if substr.isnumeric():
                            if substr in instruction_id_to_md_tag_dict:
                                sublogger.debug("\treplaced: " + split_line[idx] + " with " + instruction_id_to_md_tag_dict[substr])
                                split_line[idx] = instruction_id_to_md_tag_dict[substr]
                    else:
                        split_substr = substr.split("|")
                        instruction_id = split_substr[0]
                        dependency_data = split_substr[1]

                        if instruction_id.isnumeric():
                            if instruction_id in instruction_id_to_md_tag_dict:
                                # create the updated string and substitute
                                updated_substr = instruction_id_to_md_tag_dict[instruction_id] + "|" + dependency_data
                                sublogger.debug("\treplaced: " + split_line[idx] + " with " + updated_substr)
                                split_line[idx] = updated_substr


                updated_line = " ".join(split_line)
                updated_line = updated_line + "\n"
                sublogger.debug("updt: "+updated_line)
                sublogger.debug(" ")

                # write output line
                of.write(updated_line)    




def __get_instruction_id_to_md_tag_dict(arguments: PerfoGraphCompatibilityArguments) -> Dict[str, str]:
    """extract metadata tag to instruction id mapping from the LLVM IR file and store it in a dictionary"""
    sublogger = logger.getChild("__get_instruction_md_tag_to_id_dict")
    instruction_id_to_md_tag_dict: Dict[str, str] = dict()

    with open(arguments.llvm_ir_file, "r") as f:
        for line in f.readlines():
            line=line.replace("\n", "")
            # identify relevant lines
            if not line.startswith("!"):
                continue
            if "dp.md.instr.id" not in line:
                continue
            # unpack lines
            sublogger.debug("Unpacking line: "+ line)
            split_line = line.split(" ")
            sublogger.debug("\tsplit: " + str(split_line))
            md_tag = split_line[0]
            raw_instruction_id = split_line[2]  # example: !{!"dp.md.instr.id:179"}
            sublogger.debug("\tmd_tag: " + md_tag)
            sublogger.debug("\traw_instruction_id: " + raw_instruction_id)  
            instruction_id_str = raw_instruction_id[raw_instruction_id.find(":") + 1: raw_instruction_id.rfind("\"")]
            sublogger.debug("\tinstruction_id: " + instruction_id_str)
            # fill dictionary
            instruction_id_to_md_tag_dict[instruction_id_str] = md_tag
    
    instruction_id_to_md_tag_dict["0"] = "*"
    
    sublogger.debug("Instruction_id_to_md_tag_dict: ")
    sublogger.debug(str(instruction_id_to_md_tag_dict))
    return instruction_id_to_md_tag_dict


if __name__ == "__main__":
   main()