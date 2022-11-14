# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import os

import jsons


class Settings(object):
    initialized = False
    clang: str = ""
    clangpp: str = ""
    llvm_ar: str = ""
    llvm_link: str = ""
    llvm_dis: str = ""
    llvm_opt: str = ""
    llvm_llc: str = ""
    go_bin: str = ""

    def init_from_values(self, values: dict):
        """values stems from reading the 'add_configuration' form."""
        for key in values:
            values[key] = values[key].replace("\n", ";;")
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
        import jsons
        return jsons.dumps(self)


def load_from_config_file(config_dir: str) -> Settings:
    json_str = ""
    with open(os.path.join(config_dir, "SETTINGS.txt"), "r") as f:
        for line in f.readlines():
            json_str += line
    value_dict = jsons.loads(json_str)
    settings = Settings()
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
