# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from abc import abstractmethod
import tkinter as tk

class Base:
    @abstractmethod
    def create_frame(self, name: str) -> tk.Frame:
        pass

    @abstractmethod
    def get_frame(self, name: str) -> tk.Frame:
        pass

    @abstractmethod
    def show_frame(self, name: str) -> None:
        pass

    @abstractmethod
    def delete_frame(self, name: str) -> None:
        pass

    @abstractmethod
    def run(self) -> None:
        pass 