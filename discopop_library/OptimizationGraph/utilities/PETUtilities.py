from typing import List, Optional, cast, Set

from discopop_explorer.PETGraphX import PETGraphX, NodeID, CUNode


def identify_merge_node(pet: PETGraphX, successors: List[NodeID]) -> Optional[NodeID]:
    def check_validity_of_potential_merge_node(node_id: NodeID):
        # return True if the given node is a valid merge node.
        # return False otherwise.
        # do not allow return BB's as merge nodes, since this would be trivially true for every path split
        potential_merge_node = pet.node_at(node_id)
        if type(potential_merge_node) != CUNode:
            return False
        if (
            "return" in str(cast(CUNode, potential_merge_node).basic_block_id)
            and potential_merge_node.end_position()
            == pet.get_parent_function(potential_merge_node).end_position()
        ):
            # do not consider return BB as merge node
            return False
        return True

    if len(successors) == 0:
        raise ValueError("Empty list of successors!")

    parent_function = pet.get_parent_function(pet.node_at(successors[0]))
    post_dominators = parent_function.get_immediate_post_dominators(pet)

    # initialize lists of current post dominators
    current_post_dominators: List[NodeID] = [post_dominators[node_id] for node_id in successors]
    # initialize lists of visited post dominators for each node in "successors"
    visited_post_dominators: List[Set[NodeID]] = []
    for idx, cpd in enumerate(current_post_dominators):
        # add the node itself as well as it's first post dominator to visited nodes for the initialization
        visited_post_dominators.append({cpd, successors[idx]})

    if len(visited_post_dominators) == 0 and len(current_post_dominators) == 0:
        raise ValueError("No post dominators found!")

    # check for common post dominators
    while True:
        # check if a common post dominator exists
        common_post_dominators = visited_post_dominators[0]
        for idx, vpd_set in enumerate(visited_post_dominators):
            common_post_dominators.intersection_update(vpd_set)
            if len(common_post_dominators) == 0:
                break

        if len(common_post_dominators) > 0:
            # return identified merge node
            for potential_merge_node_id in common_post_dominators:
                if check_validity_of_potential_merge_node(potential_merge_node_id):
                    return potential_merge_node_id

        if len(current_post_dominators) == 0:
            # No merge node found and no node to be checked anymore. Exit the loop.
            break

        # if not, add current post dominators to the visited list and resolve each post dominator by one step
        # break if new post dominator is equal to the old (end of path reached)
        for idx, cpd in enumerate(current_post_dominators):
            visited_post_dominators[idx].add(cpd)
        new_post_dominators = []
        for cpd in current_post_dominators:
            if cpd not in post_dominators:
                post_dominators[cpd] = cpd
            tmp = post_dominators[cpd]
            if tmp == cpd:
                # end of path reached, do not add tmp to list of new post dominators
                continue
            # get the next post dominator
            new_post_dominators.append(tmp)
        # replace the list of current post dominators (~ frontier)
        current_post_dominators = new_post_dominators
    # no merge node found
    return None
