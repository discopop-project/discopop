# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

import pytermgui as ptg

def push_full_log_screen(manager: ptg.WindowManager, wizard):
    body = (
        ptg.Window(
            display_log_lines(manager, wizard),
            box="DOUBLE",
        )
        .set_title("[210 bold]DiscoPoP Configuration Wizard")
    )
    body.overflow = ptg.Overflow.SCROLL

    wizard.show_body_windows(manager, [(body, 0.95)])

def display_log_lines(manager: ptg.WindowManager, wizard) -> ptg.Container:
    # add log lines to container
    container = ptg.Container()
    for line in wizard.full_log:
        label = ptg.Label(line)
        label.parent_align = ptg.enums.HorizontalAlignment.LEFT
        container.lazy_add(label)
    return container