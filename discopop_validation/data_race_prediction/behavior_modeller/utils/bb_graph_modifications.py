from discopop_validation.data_race_prediction.behavior_modeller.classes.Operation import Operation


def insert_critical_sections(bb_graph, parallelization_suggestions):
    # insert critical sections (locking statements to random hash values) into bb_graph
    if "critical_section" in parallelization_suggestions:
        for critical_section in parallelization_suggestions["critical_section"]:
            cs_file_id = int(critical_section["start_line"].split(":")[0])
            cs_start_line = int(critical_section["start_line"].split(":")[1])
            cs_end_line = int(critical_section["end_line"].split(":")[1])
            # iterate over bb graph nodes
            for bb_node_id in bb_graph.graph.nodes:
                bb_node = bb_graph.graph.nodes[bb_node_id]["data"]
                # check if critical section is contained in bb_node
                if not cs_file_id == bb_node.file_id:
                    continue
                if not bb_node.start_pos[0] <= cs_start_line:
                    continue
                if not bb_node.end_pos[0] >= cs_end_line:
                    continue
                # determine insertion points of locking instructions into list of operations
                insert_idx_lock = 0
                insert_idx_unlock = len(bb_node.operations)
                operation_lines = [op.line for op in bb_node.operations]
                # determine lock index
                for idx, operation_line in enumerate(operation_lines):
                    if operation_line >= cs_start_line:
                        insert_idx_lock = idx
                        break
                # determine unlock index
                while insert_idx_unlock > 0 and operation_lines[insert_idx_unlock - 1] > cs_end_line:
                    insert_idx_unlock -= 1
                unlock_column = bb_node.operations[insert_idx_unlock-1].col + 1
                # get random "variable" name to lock
                import random
                hash = random.getrandbits(128)
                hash = "%032x" % hash
                # insert unlock operation
                unlock_operation = Operation("critical_section", None, None, "u", hash, cs_end_line, unlock_column, cs_end_line, unlock_column)
                bb_node.operations.insert(insert_idx_unlock, unlock_operation)
                # insert lock operation
                lock_operation = Operation("critical_section", None, None, "l", hash, cs_start_line, unlock_column, cs_start_line, unlock_column)
                bb_node.operations.insert(insert_idx_lock, lock_operation)