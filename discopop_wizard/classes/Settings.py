# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import os
import shutil

import jsons


class Settings(object):
    initialized = False
    discopop_dir: str = ""
    discopop_build_dir: str = ""
    clang: str = ""
    clangpp: str = ""
    llvm_ar: str = ""
    llvm_link: str = ""
    llvm_dis: str = ""
    llvm_opt: str = ""
    llvm_llc: str = ""
    go_bin: str = ""

    def __init__(self) -> None:
        # try and find default values for executables
        self.llvm_llc = "" if shutil.which("llc-11") is None else shutil.which("llc-11")
        self.llvm_opt = "" if shutil.which("opt-11") is None else shutil.which("opt-11")
        self.llvm_dis = "" if shutil.which("llvm-dis-11") is None else shutil.which("llvm-dis-11")
        self.llvm_link = "" if shutil.which("llvm-link-11") is None else shutil.which("llvm-link-11")
        self.llvm_ar = "" if shutil.which("llvm-ar-11") is None else shutil.which("llvm-ar-11")
        self.clangpp = "" if shutil.which("clang++") is None else shutil.which("clang++")
        self.clang = "" if shutil.which("clang") is None else shutil.which("clang")

    def init_from_values(self, values: dict):
        """values stems from reading the 'add_configuration' form."""
        for key in values:
            values[key] = values[key].replace("\n", ";;")
        self.discopop_dir = values["DiscoPoP directory: "]
        self.discopop_build_dir = values["DiscoPoP build: "]
        self.clang = values["clang (exe): "]
        self.clangpp = values["clang++ (exe): "]
        self.llvm_ar = values["llvm-ar (exe): "]
        self.llvm_link = values["llvm-link (exe): "]
        self.llvm_dis = values["llvm-dis (exe): "]
        self.llvm_opt = values["llvm-opt (exe): "]
        self.llvm_llc = values["llvm-llc (exe): "]
        self.go_bin = values["go (bin directory): "]
        self.initialized = True

    def get_as_json_string(self) -> str:
        """returns a representation of the settings which will be stored in a configuration file."""
        return jsons.dumps(self)


def load_from_config_file(config_dir: str) -> Settings:
    json_str = ""
    with open(os.path.join(config_dir, "SETTINGS.txt"), "r") as f:
        for line in f.readlines():
            json_str += line
    value_dict = jsons.loads(json_str)
    settings = Settings()
    settings.discopop_dir = value_dict["discopop_dir"]
    settings.discopop_build_dir = value_dict["discopop_build_dir"]
    settings.clang = value_dict["clang"]
    settings.clangpp = value_dict["clangpp"]
    settings.llvm_ar = value_dict["llvm_ar"]
    settings.llvm_link = value_dict["llvm_link"]
    settings.llvm_dis = value_dict["llvm_dis"]
    settings.llvm_opt = value_dict["llvm_opt"]
    settings.llvm_llc = value_dict["llvm_llc"]
    settings.go_bin = value_dict["go_bin"]
    settings.initialized = True
    return settings
