# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import List
from discopop_library.discopop_optimizer.OptimizerArguments import OptimizerArguments
from discopop_library.discopop_optimizer.classes.context.Update import Update
from discopop_library.result_classes.OptimizerOutputPattern import OptimizerOutputPattern


def remove_duplicated_updates(configuration: OptimizerOutputPattern, arguments: OptimizerArguments):
    cleaned_updates: List[Update] = []
    buffer: List[str] = []

    def get_buffer_str(updt, ignore_first_update=False):
        if ignore_first_update:
            result_str = ""
        else:
            result_str = "F" if updt.is_first_data_occurrence else ""
        return (
            result_str
            + "U("
            + str(updt.source_node_id)
            + "@"
            + str(updt.source_device_id)
            + ","
            + str(updt.target_node_id)
            + "@"
            + str(updt.target_device_id)
            + ","
            + str(updt.write_data_access.var_name)
            + ")"
        )

    # remove general duplicates
    for update in configuration.data_movement:
        if get_buffer_str(update) not in buffer:
            cleaned_updates.append(update)
            buffer.append(get_buffer_str(update))
        else:
            # duplicate found. Ignore.
            pass
    configuration.data_movement = cleaned_updates

    # remove update <-> first update duplicates
    buffer = []
    cleaned_updates = []
    regular_updates = [u for u in configuration.data_movement if not u.is_first_data_occurrence]
    first_updates = [u for u in configuration.data_movement if u.is_first_data_occurrence]
    # add first updates to cleaned list
    for update in first_updates:
        if get_buffer_str(update, ignore_first_update=True) not in buffer:
            cleaned_updates.append(update)
            buffer.append(get_buffer_str(update, ignore_first_update=True))
        else:
            # duplicate found. Ignore
            pass
    # check for duplicates in regular updates
    for update in regular_updates:
        if get_buffer_str(update, ignore_first_update=True) not in buffer:
            cleaned_updates.append(update)
            buffer.append(get_buffer_str(update, ignore_first_update=True))
        else:
            # duplicate found. Ignore
            pass
    configuration.data_movement = cleaned_updates

    if arguments.verbose:
        print("Removed duplicates from updates")
        for update in configuration.data_movement:
            print("# ", update)
        print()

    return configuration
