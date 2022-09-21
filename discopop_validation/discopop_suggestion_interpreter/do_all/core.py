from discopop_validation.classes.OmpPragma import OmpPragma


def interpret_do_all_suggestion(suggestion) -> OmpPragma:
    # unpack suggestion
    file_id = suggestion["node_id"].split(":")[0]
    start_line = suggestion["start_line"].split(":")[1]
    end_line = suggestion["end_line"].split(":")[1]

    first_privates = " ".join([var + "," for var in suggestion["first_private"] if var is not None])
    privates = " ".join([var + "," for var in suggestion["private"] if var is not None])
    last_privates = " ".join([var + "," for var in suggestion["last_private"] if var is not None])
    shared = " ".join([var + "," for var in suggestion["shared"] if var is not None])
    reduction = " ".join([var + "," for var in suggestion["reduction"] if var is not None])

    # construct omp pragma
    pragma = "parallel for "
    pragma += "firstprivate(" + first_privates + ") "
    pragma += "private(" + privates + ") "
    pragma += "lastprivate(" + last_privates + ") "
    pragma += "shared(" + shared + ") "
    pragma += "reduction(" + reduction + ") "

    # return OmpPragma object
    return OmpPragma().init_with_values(file_id, start_line, end_line, pragma)
