from discopop_explorer import PETGraphX


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
    # find narrowest matching node
    narrowest_node_buffer = potential_nodes[0]
    for pet_node in potential_nodes:
        if pet.g.nodes[pet_node]["data"].start_line >= pet.g.nodes[narrowest_node_buffer]["data"].start_line and \
            pet.g.nodes[pet_node]["data"].end_line <= pet.g.nodes[narrowest_node_buffer]["data"].end_line:
            narrowest_node_buffer = pet_node
    return narrowest_node_buffer