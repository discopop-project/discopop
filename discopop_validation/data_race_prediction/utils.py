from discopop_explorer import PETGraphX
from discopop_explorer.PETGraphX import EdgeType
from discopop_validation.interfaces.discopop_explorer import check_reachability


def get_pet_node_id_from_source_code_lines(pet: PETGraphX, file_id: int, start_line: int, end_line: int):
    """Returns the ID of the pet-graph node which contains the given pragma"""
    potential_nodes = []
    for pet_node in pet.g.nodes:
        if file_id == pet.g.nodes[pet_node]["data"].file_id and \
            start_line >= pet.g.nodes[pet_node]["data"].start_line and \
            end_line <= pet.g.nodes[pet_node]["data"].end_line:
            potential_nodes.append(pet_node)
    if len(potential_nodes) == 0:
        raise ValueError("No valid CUID found for: ", str(file_id) + ":"+ str(start_line)+"-"+str(end_line))

    # if two potential nodes have equal lines, select the parent and remove the child cu from the list of potential nodes
    buffer = dict()
    for pet_node in potential_nodes:
        start_line = pet.g.nodes[pet_node]["data"].start_line
        end_line = pet.g.nodes[pet_node]["data"].end_line
        if (start_line, end_line) in buffer:
            buffer[(start_line, end_line)].append(pet_node)
        else:
            buffer[(start_line, end_line)] = [pet_node]
    to_be_removed = []
    for key in buffer:
        if len(buffer[key]) < 2:
            continue
        # check forward
        for idx, potential in enumerate(sorted(buffer[key])):
            # check if idx is a parent of idx+1
            if idx + 1 < len(buffer[key]):
                if check_reachability(pet, pet.node_at(sorted(buffer[key])[idx+1]), pet.node_at(potential), [EdgeType.CHILD]):
                    to_be_removed.append(sorted(buffer[key])[idx+1])
        # check backwards
        for idx, potential in enumerate(sorted(buffer[key], reverse=True)):
            # check if idx is a parent of idx+1
            if idx + 1 < len(buffer[key]):
                if check_reachability(pet, pet.node_at(sorted(buffer[key], reverse=True)[idx+1]), pet.node_at(potential), [EdgeType.CHILD]):
                    to_be_removed.append(sorted(buffer[key], reverse=True)[idx+1])

    for pet_node in to_be_removed:
        potential_nodes.remove(pet_node)

    # find narrowest matching node
    narrowest_node_buffer = potential_nodes[0]
    for pet_node in potential_nodes:
        if pet.g.nodes[pet_node]["data"].start_line >= pet.g.nodes[narrowest_node_buffer]["data"].start_line and \
            pet.g.nodes[pet_node]["data"].end_line <= pet.g.nodes[narrowest_node_buffer]["data"].end_line:
            narrowest_node_buffer = pet_node
    return narrowest_node_buffer