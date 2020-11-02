# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import logging
import os
import re
import subprocess
from contextlib import suppress
from typing import List

from ._version import __version__
from .utils import recursive_scandir, is_compile, is_link, get_library


class DiscopopCpp:
    def __init__(
        self,
        cugeneration: bool,
        dpinstrumentation: bool,
        dpreduction: bool,
        clang_path: str,
    ):
        self.cugeneration = cugeneration
        self.dpinstrumentation = dpinstrumentation
        self.dpreduction = dpreduction
        self.clang_path = clang_path

    def update_filemapping(self):
        cwd = os.getcwd()
        with suppress(FileNotFoundError):
            # Do not regenerate if FileMapping.txt is still up-to-date.
            filemapping_mtime = os.stat("FileMapping.txt").st_mtime
            if os.stat(cwd).st_mtime < filemapping_mtime and all(
                [
                    not entry.is_dir() or entry.stat().st_mtime < filemapping_mtime
                    for entry in recursive_scandir(cwd)
                ]
            ):
                return
        logging.info("Generating FileMapping.txt.")
        with open("FileMapping.txt", "w") as fd:
            i = 1
            for entry in sorted(recursive_scandir(cwd), key=lambda e: e.path):
                if entry.is_file() and re.match(r"^[^.].+\.(?:c|cc|cpp|h|hpp|ipp)$", entry.name):
                    print(f"{i}\t{entry.path}", file=fd)
                    i += 1

    def wrap_clang_args(self, clang_args: List[str]) -> List[str]:
        args = [self.clang_path]
        if is_compile(clang_args):
            if any([self.cugeneration, self.dpinstrumentation, self.dpreduction]):
                self.update_filemapping()
                args += ["-g", "-O0", "-fno-discard-value-names"]
                if self.cugeneration:
                    # clang++ -g -O0 -fno-discard-value-names -Xclang -load \
                    #   -Xclang ${DISCOPOP_INSTALL}/libi/LLVMCUGeneration.so \
                    #   -mllvm -fm-path -mllvm ./FileMapping.txt -c <C_File>
                    args += ["-Xclang", "-load", "-Xclang", get_library("LLVMCUGeneration.so")]
                if self.dpinstrumentation:
                    # clang++ -g -O0 -fno-discard-value-names -Xclang -load \
                    #   -Xclang ${DISCOPOP_INSTALL}/libi/LLVMDPInstrumentation.so \
                    #   -mllvm -fm-path -mllvm ./FileMapping.txt -c <C_File> -o out.o
                    args += ["-Xclang", "-load", "-Xclang", get_library("LLVMDPInstrumentation.so")]
                if self.dpreduction:
                    # clang++ -g -O0 -fno-discard-value-names -Xclang -load \
                    #   -Xclang ${DISCOPOP_INSTALL}/libi/LLVMDPReduction.so \
                    #   -mllvm -fm-path -mllvm ./FileMapping.txt -c <C_File> -o out.o
                    args += ["-Xclang", "-load", "-Xclang", get_library("LLVMDPReduction.so")]
                args += ["-mllvm", "-fm-path", "-mllvm", "./FileMapping.txt"]
        args += clang_args
        if is_link(clang_args):
            if self.dpinstrumentation or self.dpreduction:
                # clang++ out.o -L${DISCOPOP_INSTALL}/rtlib -lDiscoPoP_RT -lpthread
                args += [
                    f"-L{os.path.dirname(get_library('libDiscoPoP_RT.a'))}",
                    "-lDiscoPoP_RT",
                    "-lpthread",
                ]
        return args

    def invoke(self, clang_args: List[str]) -> subprocess.CompletedProcess:
        args = self.wrap_clang_args(clang_args)
        logging.info(" ".join(args))
        return subprocess.run(args)
