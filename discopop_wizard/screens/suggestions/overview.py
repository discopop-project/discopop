# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import copy
from typing import List

import pytermgui as ptg
import os

from discopop_wizard.classes.Suggestions import Suggestion


def push_suggestion_overview_screen(manager: ptg.WindowManager, config_dir: str, wizard, exec_config_obj):
    # suggestions are stored in exec_config_obj.project_path/patterns.txt
    suggestions_path = os.path.join(exec_config_obj.project_path, "patterns.txt")

    raw_patterns = (
        ptg.Window(
            "",
            ptg.Label(open(suggestions_path, "r").read(), parent_align=ptg.enums.HorizontalAlignment.LEFT),
            "",
            box="DOUBLE",
        )
        .set_title("[210 bold]Raw Parallelization Suggestions")
    )
    raw_patterns.overflow = ptg.Overflow.SCROLL;

    code_section = (
        ptg.Window(
            box="DOUBLE",
        )
        .set_title("Code Section")
    )

    details_section = (
        ptg.Window(
            box="DOUBLE"
        )
        .set_title("Details")
    )

    collabsible_patterns = (
        ptg.Window(
            get_suggestion_view(manager, suggestions_path, wizard, exec_config_obj),
            box="DOUBLE",
        )
        .set_title("[210 bold]Suggestions by Type")
    )
    collabsible_patterns.overflow = ptg.Overflow.SCROLL;


#    buttons = (ptg.Window(
#        ["Save", lambda *_: save_configuration(manager, body, config_dir, wizard)],
#    ))
    wizard.show_body_windows(manager, [(collabsible_patterns, 0.2), (details_section, 0.2), (code_section, 0.55)])

def get_suggestion_view(manager: ptg.WindowManager, suggestions_path: str, wizard, exec_config_obj) -> ptg.Container:
    container = ptg.Container()

    # todo load json or python objects instead
    suggestions: List[str] = []
    current_suggestion: str = ""
    for line in open(suggestions_path, "r").readlines():
        if line.startswith("Pipeline at:") or line.startswith("Reduction at:") or \
                line.startswith("Do-all at:") or line.startswith("Geometric decomposition at:"):
            suggestions.append(current_suggestion)
            current_suggestion = ""
        current_suggestion += line
    suggestions.append(current_suggestion)
    suggestions = [s for s in suggestions if len(s) > 0]

    suggestion_objects = []
    for idx, suggestion in enumerate(suggestions):
        suggestion_objects.append(Suggestion(idx, suggestion))

    for suggestion in suggestion_objects:
        container.lazy_add(suggestion.get_as_button(manager, wizard, exec_config_obj))
    return container






