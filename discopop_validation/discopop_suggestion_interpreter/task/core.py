from discopop_validation.classes.OmpPragma import OmpPragma


def interpret_task_suggestion(suggestion) -> OmpPragma:
    # unpack suggestion
    file_id = suggestion["node_id"].split(":")[0]
    start_line = suggestion["region_start_line"].split(":")[1]
    print("START LINE: ", start_line)
    end_line = suggestion["region_end_line"].split(":")[1]

    first_privates = " ".join([var + "," for var in suggestion["first_private"]])
    privates = " ".join([var + "," for var in suggestion["private"]])
    last_privates = " ".join([var + "," for var in suggestion["last_private"]])
    shared = " ".join([var + "," for var in suggestion["shared"]])
    in_dep = " ".join([var + "," for var in suggestion["in_dep"]])
    out_dep = " ".join([var + "," for var in suggestion["out_dep"]])
    in_out_dep = " ".join([var + "," for var in suggestion["in_out_dep"]])

    # todo include and implement atomic and critical sections

    # construct omp pragma
    pragma = "parallel for "
    pragma += "firstprivate(" + first_privates + ") "
    pragma += "private(" + privates + ") "
    pragma += "lastprivate(" + last_privates + ") "
    pragma += "shared(" + shared + ") "
    pragma += "depend(" + shared + ") "

    # return OmpPragma object
    return OmpPragma().init_with_values(file_id, start_line, end_line, pragma)
