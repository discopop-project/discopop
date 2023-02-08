from typing import Dict, Set, cast

from discopop_explorer.PETGraphX import PETGraphX
from discopop_explorer.pattern_detectors.combined_gpu_patterns.classes.Aliases import (
    MemoryRegion,
    CUID,
    VarName,
)


def propagate_variable_name_associations(
    pet: PETGraphX,
    memory_regions_to_cus_and_variables: Dict[MemoryRegion, Dict[CUID, Set[VarName]]],
) -> Dict[MemoryRegion, Dict[CUID, Set[VarName]]]:
    """Replaces individual cu ids with id's of their parent functions."""
    updated_dict: Dict[MemoryRegion, Dict[CUID, Set[VarName]]] = dict()

    for mem_reg in memory_regions_to_cus_and_variables:
        for cu_id in memory_regions_to_cus_and_variables[mem_reg]:
            var_names = memory_regions_to_cus_and_variables[mem_reg][cu_id]
            cu_node = pet.node_at(cu_id)
            # get parent function
            parent = pet.get_parent_function(cu_node)

            # save variable name association for parent function
            if mem_reg not in updated_dict:
                updated_dict[mem_reg] = dict()
            if parent.id not in updated_dict[mem_reg]:
                updated_dict[mem_reg][cast(CUID, parent.id)] = set()
            updated_dict[mem_reg][cast(CUID, parent.id)].update(var_names)

    return updated_dict
