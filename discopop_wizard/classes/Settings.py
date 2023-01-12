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
import tkinter as tk

class Settings(object):
    # general settings
    initialized = False
    discopop_build_dir: str = ""
    clang: str = ""
    clangpp: str = ""
    llvm_ar: str = ""
    llvm_link: str = ""
    llvm_dis: str = ""
    llvm_opt: str = ""
    llvm_llc: str = ""
    go_bin: str = ""
    use_docker_container_for_profiling: bool = True

    # code preview settings
    code_preview_show_metadata_regions: int = 1  # 1 = True, 0 = False
    code_preview_show_metadata_live_device_variables: int = 1  # 1 = True, 0 = False
    code_preview_show_line_numbers: int = 1  # 1 = True, 0 = False

    def __init__(self, discopop_build_dir="", go_bin_dir="", use_docker_container: bool = True) -> None:
        self.discopop_build_dir = discopop_build_dir
        self.go_bin = go_bin_dir
        self.use_docker_container_for_profiling = use_docker_container
        # validate settings
        settings_valid = os.path.exists(self.discopop_build_dir) and os.path.exists(self.go_bin)

        # get llvm_bin_dir from stored build configuration
        llvm_bin_dir = ""
        if settings_valid:
            command = 'cat ' + self.discopop_build_dir + '/build_config.txt | grep -oP "(?<=LLVM_BIN_DIR=).*"'
            llvm_bin_dir = os.popen(command).read().replace("\n", "")
            if not os.path.exists(llvm_bin_dir):
                llvm_bin_dir = ""

        # try and find default values using llvm_bin_dir and shutil.which
        if os.path.exists(os.path.join(llvm_bin_dir, "clang")):
            self.clang = os.path.join(llvm_bin_dir, "clang")
        else:
            self.clang = "" if shutil.which("clang") is None else shutil.which("clang")

        if os.path.exists(os.path.join(llvm_bin_dir, "clang++")):
            self.clangpp = os.path.join(llvm_bin_dir, "clang++")
        else:
            self.clangpp = "" if shutil.which("clang++") is None else shutil.which("clang++")

        if os.path.exists(os.path.join(llvm_bin_dir, "llvm-ar")):
            self.llvm_ar = os.path.join(llvm_bin_dir, "llvm-ar")
        else:
            self.llvm_ar = "" if shutil.which("llvm-ar-11") is None else shutil.which("llvm-ar-11")

        if os.path.exists(os.path.join(llvm_bin_dir, "llvm-link")):
            self.llvm_link = os.path.join(llvm_bin_dir, "llvm-link")
        else:
            self.llvm_link = "" if shutil.which("llvm-link-11") is None else shutil.which("llvm-link-11")

        if os.path.exists(os.path.join(llvm_bin_dir, "llvm-dis")):
            self.llvm_dis = os.path.join(llvm_bin_dir, "llvm-dis")
        else:
            self.llvm_dis = "" if shutil.which("llvm-dis-11") is None else shutil.which("llvm-dis-11")

        if os.path.exists(os.path.join(llvm_bin_dir, "opt")):
            self.llvm_opt = os.path.join(llvm_bin_dir, "opt")
        else:
            self.llvm_opt = "" if shutil.which("opt-11") is None else shutil.which("opt-11")

        if os.path.exists(os.path.join(llvm_bin_dir, "llc")):
            self.llvm_llc = os.path.join(llvm_bin_dir, "llc")
        else:
            self.llvm_llc = "" if shutil.which("llc-11") is None else shutil.which("llc-11")

        # validate settings
        settings_valid = settings_valid and len(self.clang) > 0 and len(self.clangpp) > 0 and len(self.llvm_ar) > 0 \
                         and len(self.llvm_link) > 0 and len(self.llvm_dis) > 0 and len(self.llvm_opt) > 0 and len(
            self.llvm_llc) > 0

        # set initialized, if all values could be determined and are valid, or docker container is used
        self.initialized = use_docker_container or settings_valid

    def get_as_json_string(self) -> str:
        """returns a representation of the settings which will be stored in a configuration file."""
        return jsons.dumps(self)

    def save_to_file(self, config_dir: str):
        settings_path = os.path.join(config_dir, "SETTINGS.txt")
        # remove old config if present
        if os.path.exists(settings_path):
            os.remove(settings_path)
        # write config to file
        with open(settings_path, "w+") as f:
            f.write(self.get_as_json_string())


def load_from_config_file(config_dir: str) -> Settings:
    json_str = ""
    with open(os.path.join(config_dir, "SETTINGS.txt"), "r") as f:
        for line in f.readlines():
            json_str += line
    value_dict = jsons.loads(json_str)
    settings = Settings()

    # general settings
    settings.discopop_build_dir = __load_or_get_default(value_dict, "discopop_build_dir")
    settings.clang = __load_or_get_default(value_dict, "clang")
    settings.clangpp = __load_or_get_default(value_dict, "clangpp")
    settings.llvm_ar = __load_or_get_default(value_dict, "llvm_ar")
    settings.llvm_link = __load_or_get_default(value_dict, "llvm_link")
    settings.llvm_dis = __load_or_get_default(value_dict, "llvm_dis")
    settings.llvm_opt = __load_or_get_default(value_dict, "llvm_opt")
    settings.llvm_llc = __load_or_get_default(value_dict, "llvm_llc")
    settings.go_bin = __load_or_get_default(value_dict, "go_bin")
    settings.use_docker_container_for_profiling = __load_or_get_default(value_dict,
                                                                        "use_docker_container_for_profiling")
    # code preview settings
    settings.code_preview_show_metadata_regions = value_dict["code_preview_show_metadata_regions"]
    settings.code_preview_show_line_numbers = value_dict["code_preview_show_line_numbers"]
    settings.code_preview_show_metadata_live_device_variables = value_dict["code_preview_show_metadata_live_device_variables"]

    settings.initialized = True
    return settings


def __load_or_get_default(value_dict, key_name):
    if key_name in value_dict:
        return value_dict[key_name]
    # get default value
    return getattr(Settings(), key_name)
