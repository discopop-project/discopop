# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.


import functools
from sys import platform
from enum import Enum


class Platform(Enum):
    UNKNOWN = 0
    LINUX = 1
    WINDOWS = 2
    OSX = 3


def get_platform():
    platforms = {
        'linux1': Platform.LINUX,
        'linux2': Platform.LINUX,
        'darwin': Platform.OSX,
        'win32': Platform.WINDOWS
    }
    if platform not in platforms:
        return Platform.UNKNOWN

    return platforms[platform]


def support_scrolling(canvas):
    # add support for mouse wheel scrolling (on linux systems)
    def _on_mousewheel(event, scroll):
        canvas.yview_scroll(int(scroll), "units")

    def _bind_to_mousewheel(event):
        pf = get_platform()
        if pf == Platform.LINUX:
            canvas.bind_all("<Button-4>", functools.partial(_on_mousewheel, scroll=-1))
            canvas.bind_all("<Button-5>", functools.partial(_on_mousewheel, scroll=1))
        elif pf == Platform.WINDOWS:
            canvas.bind_all("<MouseWheel>", functools.partial(_on_mousewheel, scroll=(-1 * (event.delta / 120))))
        elif pf == Platform.OSX:
            canvas.bind_all("<MouseWheel>", functools.partial(_on_mousewheel, scroll=-1 * event.delta))
        else:
            canvas.bind_all("<Button-4>", functools.partial(_on_mousewheel, scroll=-1))
            canvas.bind_all("<Button-5>", functools.partial(_on_mousewheel, scroll=1))

    def _unbind_from_mousewheel(event):
        pf = get_platform()
        if pf == Platform.LINUX:
            canvas.unbind_all("<Button-4>")
            canvas.unbind_all("<Button-5>")
        elif pf == Platform.WINDOWS or pf == Platform.OSX:
            canvas.unbind_all("<MouseWheel>")
        else:
            canvas.unbind_all("<Button-4>")
            canvas.unbind_all("<Button-5>")

    canvas.bind('<Enter>', _bind_to_mousewheel)
    canvas.bind('<Leave>', _unbind_from_mousewheel)
