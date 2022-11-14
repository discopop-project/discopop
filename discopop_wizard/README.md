<!--
# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
-->

# Install dependencies

    python -m pip install -r requirements.txt

# Executing the DiscoPoP Wizard
Navigate to the root folder of the project (`discopop` directory).
From there, the wizard can be started by simply executing:

    python -m discopop_wizard

# Navigation
Although theoretically possible, it is strongly recommended to use the mouse to navigate through the menus.

# Colors
As the colors may be different from system to system and potential issues in the displayed program may arise,
it is possible to disable colors and improve the compatibility and stability of the program.
To disable colors, simply define the `NO_COLOR` environment variable upon start:

    NO_COLOR=true python -m discopop_wizard

