import copy
import os
from typing import List

from lxml import objectify, etree  # type: ignore

from discopop_explorer.PETGraphX import NodeType, PETGraphX

from discopop_explorer.pattern_detectors.task_parallelism.tp_utils import line_contained_in_region


def cu_xml_preprocessing(cu_xml: str) -> str:
    """Execute CU XML Preprocessing.
    Returns file name of modified cu xml file.
    :param cu_xml: path to the xml file
    :return: file name of modified cu xml file.
    """
    xml_fd = open(cu_xml)
    xml_content = ""
    for line in xml_fd.readlines():
        if not (line.rstrip().endswith('</Nodes>') or line.rstrip().endswith('<Nodes>')):
            xml_content = xml_content + line

    xml_content = "<Nodes>{0}</Nodes>".format(xml_content)

    parsed_cu = objectify.fromstring(xml_content)

    iterate_over_cus = True  # used to enable re-starting
    self_added_node_ids: List[str] = []
    while iterate_over_cus:
        used_node_ids = []
        for node in parsed_cu.Node:
            used_node_ids.append(node.get("id"))

        for node in parsed_cu.Node:
            inner_iteration = True
            remaining_recursive_call_in_parent = False
            while inner_iteration:
                used_node_ids = list(set(used_node_ids + self_added_node_ids))

                if node.get('type') == '0':  # iterate over CU nodes
                    # find CU nodes with > 1 recursiveFunctionCalls in own code region
                    if __preprocessor_cu_contains_at_least_two_recursive_calls(
                            node) or remaining_recursive_call_in_parent:
                        remaining_recursive_call_in_parent = False
                        # Preprocessor Step 1
                        tmp_cn_entry = None  # (recursiveFunctionCall, nodeCalled)
                        for cne_idx, calls_node_entry in enumerate(node.callsNode):
                            # get first matching entry of node.callsNode
                            try:
                                for rc_idx, rec_call in enumerate(calls_node_entry.recursiveFunctionCall):
                                    rec_call_line = calls_node_entry.nodeCalled[rc_idx].get("atLine")
                                    if str(rec_call_line) in str(rec_call):
                                        tmp_cn_entry = (rec_call, calls_node_entry.nodeCalled[rc_idx])
                                        break
                            except AttributeError:
                                continue
                        if tmp_cn_entry is None:
                            raise Exception("no matching entries for callsNode found!")

                        parent = node
                        tmp_cn_entry[0].getparent().remove(tmp_cn_entry[0])
                        tmp_cn_entry[1].getparent().remove(tmp_cn_entry[1])
                        parent_copy = copy.copy(parent)
                        parsed_cu.insert(parsed_cu.index(parent), parent_copy)

                        # Preprocessor Step 2 - generate cu id for new element
                        # get next free id for specific tmp_file_id
                        parent_copy_id = parent_copy.get("id")
                        tmp_file_id = parent_copy_id[:parent_copy_id.index(":")]
                        tmp_used_ids = [int(s[s.index(":") + 1:]) for s in
                                        used_node_ids if
                                        s.startswith(tmp_file_id + ":")]
                        next_free_id = max(tmp_used_ids) + 1
                        incremented_id = tmp_file_id + ":" + str(next_free_id)
                        parent.set("id", incremented_id)
                        self_added_node_ids.append(incremented_id)

                        # Preprocessor Step 3
                        parent_copy.callsNode.clear()
                        parent_copy.callsNode.append(tmp_cn_entry[1])
                        parent_copy.callsNode.append(tmp_cn_entry[0])

                        parent_copy.successors.clear()
                        etree.SubElement(parent_copy.successors, "CU")
                        parent_copy.successors.CU._setText(parent.get("id"))

                        # delete childrenNodes-entry from parent
                        tmp_cu_id = tmp_cn_entry[1].text
                        parent.childrenNodes._setText(parent.childrenNodes.text.replace(tmp_cu_id + ",", ""))
                        parent.childrenNodes._setText(parent.childrenNodes.text.replace(tmp_cu_id, ""))

                        # set parent_copy.childrenNodes
                        parent_copy.childrenNodes._setText("")
                        for cne_idx, calls_node_entry in enumerate(parent_copy.callsNode):
                            try:
                                for node_call in calls_node_entry.nodeCalled:
                                    try:
                                        if node_call.text not in parent_copy.childrenNodes.text:
                                            parent_copy.childrenNodes._setText(
                                                parent_copy.childrenNodes.text + "," + node_call.text)
                                            if parent_copy.childrenNodes.text.startswith(","):
                                                parent_copy.childrenNodes._setText(parent_copy.childrenNodes.text[1:])
                                            if parent_copy.childrenNodes.text.endswith(","):
                                                parent_copy.childrenNodes._setText(parent_copy.childrenNodes.text[:-1])
                                            continue
                                    except AttributeError as e1:
                                        print(e1)
                                        continue
                            except AttributeError as e2:
                                print(e2)
                                continue

                        # Preprocessor Step 4
                        # update startsAtLine and endsAtLine
                        try:
                            if parent_copy.callsNode.nodeCalled.get("atLine") in \
                                    parent.instructionLines.text:
                                parent.instructionLines._setText(parent.instructionLines.text.replace(
                                    parent_copy.callsNode.nodeCalled.get("atLine") + ",", ""))
                                parent.instructionLines._setText(
                                    parent.instructionLines.text.replace(parent_copy.callsNode.nodeCalled.get("atLine"),
                                                                         ""))
                                parent.instructionLines.set("count", str(int(parent.instructionLines.get("count")) - 1))
                        except TypeError:
                            parent.instructionLines._setText(parent_copy.callsNode.nodeCalled.get("atLine"))
                            parent.instructionLines.set("count", "1")

                        try:
                            if parent_copy.callsNode.nodeCalled.get("atLine") in \
                                    parent.readPhaseLines.text:
                                parent.readPhaseLines._setText(parent.readPhaseLines.text.replace(
                                    parent_copy.callsNode.nodeCalled.get("atLine") + ",", ""))
                                parent.readPhaseLines._setText(
                                    parent.readPhaseLines.text.replace(parent_copy.callsNode.nodeCalled.get("atLine"),
                                                                       ""))
                                parent.readPhaseLines.set("count", str(int(parent.readPhaseLines.get("count")) - 1))
                        except TypeError:
                            parent.readPhaseLines._setText(parent_copy.callsNode.nodeCalled.get("atLine"))
                            parent.readPhaseLines.set("count", "1")

                        try:
                            if parent_copy.callsNode.nodeCalled.get("atLine") in \
                                    parent.writePhaseLines.text:
                                parent.writePhaseLines._setText(parent.writePhaseLines.text.replace(
                                    parent_copy.callsNode.nodeCalled.get("atLine") + ",", ""))
                                parent.writePhaseLines._setText(
                                    parent.writePhaseLines.text.replace(parent_copy.callsNode.nodeCalled.get("atLine"),
                                                                        ""))
                                parent.writePhaseLines.set("count", str(int(parent.writePhaseLines.get("count")) - 1))
                        except TypeError:
                            parent.writePhaseLines._setText(parent_copy.callsNode.nodeCalled.get("atLine"))
                            parent.writePhaseLines.set("count", "1")

                        separator_line = parent.get("startsAtLine")
                        # select smallest recursive function call line >= separator_line + 1
                        parent_new_start_line = None
                        potential_lines = []
                        for tmp1 in parent.callsNode:
                            try:
                                for tmp2 in tmp1.nodeCalled:
                                    try:
                                        potential_lines.append(tmp2.get("atLine"))
                                        pass
                                    except AttributeError:
                                        pass
                            except AttributeError:
                                pass
                        for tmp in potential_lines:
                            if tmp == "":
                                continue
                            if int(tmp[tmp.find(":") + 1:]) >= int(separator_line[separator_line.find(":") + 1:]) + 1:
                                if parent_new_start_line is None:
                                    parent_new_start_line = tmp
                                    continue
                                # select smallest instruction line
                                if int(tmp[tmp.find(":") + 1:]) < int(
                                        parent_new_start_line[parent_new_start_line.find(":") + 1:]):
                                    parent_new_start_line = tmp
                        if not potential_lines or (potential_lines and not parent_new_start_line):
                            parent_new_start_line = str(separator_line[:separator_line.index(":")])
                            parent_new_start_line += ":"
                            parent_new_start_line += str(int(separator_line[separator_line.index(":") + 1:]) + 1)

                        parent.set("startsAtLine", parent_new_start_line)
                        parent_copy.set("endsAtLine", separator_line)

                        # update instruction/readPhase/writePhase lines
                        try:
                            for tmp_line in parent_copy.instructionLines.text.split(","):
                                if not line_contained_in_region(
                                        tmp_line,
                                        parent_copy.get("startsAtLine"),
                                        parent_copy.get("endsAtLine")):
                                    parent_copy.instructionLines._setText(
                                        parent_copy.instructionLines.text.replace(tmp_line + ",", ""))
                                    parent_copy.instructionLines._setText(
                                        parent_copy.instructionLines.text.replace(tmp_line, ""))
                                    if parent_copy.instructionLines.text.endswith(","):
                                        parent_copy.instructionLines._setText(parent_copy.instructionLines.text[:-1])
                                    parent_copy.instructionLines.set("count", str(
                                        int(parent_copy.instructionLines.get("count")) - 1))
                        except AttributeError:
                            pass
                        try:
                            for tmp_line in parent_copy.readPhaseLines.text.split(","):
                                if not line_contained_in_region(
                                        tmp_line,
                                        parent_copy.get("startsAtLine"),
                                        parent_copy.get("endsAtLine")):
                                    parent_copy.readPhaseLines._setText(
                                        parent_copy.readPhaseLines.text.replace(tmp_line + ",", ""))
                                    parent_copy.readPhaseLines._setText(
                                        parent_copy.readPhaseLines.text.replace(tmp_line, ""))
                                    if parent_copy.readPhaseLines.text.endswith(","):
                                        parent_copy.readPhaseLines._setText(parent_copy.readPhaseLines.text[:-1])
                                    parent_copy.readPhaseLines.set("count", str(
                                        int(parent_copy.readPhaseLines.get("count")) - 1))
                        except AttributeError:
                            pass
                        try:
                            for tmp_line in parent_copy.writePhaseLines.text.split(","):
                                if not line_contained_in_region(
                                        tmp_line,
                                        parent_copy.get("startsAtLine"),
                                        parent_copy.get("endsAtLine")):
                                    parent_copy.writePhaseLines._setText(
                                        parent_copy.writePhaseLines.text.replace(tmp_line + ",", ""))
                                    parent_copy.writePhaseLines._setText(
                                        parent_copy.writePhaseLines.text.replace(tmp_line, ""))
                                    if parent_copy.writePhaseLines.text.endswith(","):
                                        parent_copy.writePhaseLines._setText(parent_copy.writePhaseLines.text[:-1])
                                    parent_copy.writePhaseLines.set("count", str(
                                        int(parent_copy.writePhaseLines.get("count")) - 1))
                        except AttributeError:
                            pass

                        # insert separator line to parent_copys instruction,
                        # read and writePhaseLines if not already present
                        try:
                            if not parent_copy.get("endsAtLine") in parent_copy.instructionLines.text:
                                parent_copy.instructionLines._setText(
                                    parent_copy.instructionLines.text + "," + parent_copy.get("endsAtLine"))
                                if parent_copy.instructionLines.text.startswith(","):
                                    parent_copy.instructionLines._setText(parent_copy.instructionLines.text[1:])
                                parent_copy.instructionLines.set("count", str(
                                    int(parent_copy.instructionLines.get("count")) + 1))
                        except TypeError:
                            parent_copy.instructionLines._setText(parent_copy.get("endsAtLine"))
                            parent_copy.instructionLines.set("count", "1")
                        try:
                            if not parent_copy.get("endsAtLine") in parent_copy.readPhaseLines.text:
                                parent_copy.readPhaseLines._setText(
                                    parent_copy.readPhaseLines.text + "," + parent_copy.get("endsAtLine"))
                                if parent_copy.readPhaseLines.text.startswith(","):
                                    parent_copy.readPhaseLines._setText(parent_copy.readPhaseLines.text[1:])
                                parent_copy.readPhaseLines.set("count",
                                                               str(int(parent_copy.readPhaseLines.get("count")) + 1))
                        except TypeError:
                            parent_copy.readPhaseLines._setText(parent_copy.get("endsAtLine"))
                            parent_copy.readPhaseLines.set("count", "1")
                        try:
                            if not parent_copy.get("endsAtLine") in parent_copy.writePhaseLines.text:
                                parent_copy.writePhaseLines._setText(
                                    parent_copy.writePhaseLines.text + "," + parent_copy.get("endsAtLine"))
                                if parent_copy.writePhaseLines.text.startswith(","):
                                    parent_copy.writePhaseLines._setText(parent_copy.writePhaseLines.text[1:])
                                parent_copy.writePhaseLines.set("count",
                                                                str(int(parent_copy.writePhaseLines.get("count")) + 1))
                        except TypeError:
                            parent_copy.writePhaseLines._setText(parent_copy.get("endsAtLine"))
                            parent_copy.writePhaseLines.set("count", "1")
                        parent_copy.instructionLines._setText(parent_copy.instructionLines.text.replace(",,", ","))
                        parent_copy.readPhaseLines._setText(parent_copy.readPhaseLines.text.replace(",,", ","))
                        parent_copy.writePhaseLines._setText(parent_copy.writePhaseLines.text.replace(",,", ","))

                        # insert all lines contained in parent to instruction, read and writePhaseLines
                        cur_line = parent.get("startsAtLine")
                        while line_contained_in_region(cur_line, parent.get("startsAtLine"),
                                                       parent.get("endsAtLine")):
                            if cur_line not in parent.instructionLines.text:
                                parent.instructionLines._setText(cur_line + "," + parent.instructionLines.text)
                                if parent.instructionLines.text.endswith(","):
                                    parent.instructionLines._setText(parent.instructionLines.text[:-1])
                                parent.instructionLines.set("count", str(int(parent.instructionLines.get("count")) + 1))
                            if cur_line not in parent.readPhaseLines.text:
                                parent.readPhaseLines._setText(cur_line + "," + parent.readPhaseLines.text)
                                if parent.readPhaseLines.text.endswith(","):
                                    parent.readPhaseLines._setText(parent.readPhaseLines.text[:-1])
                                parent.readPhaseLines.set("count", str(int(parent.readPhaseLines.get("count")) + 1))
                            if cur_line not in parent.writePhaseLines.text:
                                parent.writePhaseLines._setText(cur_line + "," + parent.writePhaseLines.text)
                                if parent.writePhaseLines.text.endswith(","):
                                    parent.writePhaseLines._setText(parent.writePhaseLines.text[:-1])
                                parent.writePhaseLines.set("count", str(int(parent.writePhaseLines.get("count")) + 1))
                            # increment cur_line by one
                            cur_line = cur_line[0:cur_line.rfind(":") + 1] + str(
                                int(cur_line[cur_line.rfind(":") + 1:]) + 1)
                            continue

                        parent.instructionLines._setText(parent.instructionLines.text.replace(",,", ","))
                        parent.readPhaseLines._setText(parent.readPhaseLines.text.replace(",,", ","))
                        parent.writePhaseLines._setText(parent.writePhaseLines.text.replace(",,", ","))

                        # remove returnInstructions if they are not part of the cus anymore
                        if int(parent_copy.returnInstructions.get("count")) != 0:
                            entries = parent_copy.returnInstructions.text.split(",")
                            new_entries = []
                            for entry in entries:
                                if line_contained_in_region(entry, parent_copy.get("startsAtLine"),
                                                            parent_copy.get("endsAtLine")):
                                    new_entries.append(entry)
                            parent_copy.returnInstructions._setText(",".join(new_entries))
                            parent_copy.returnInstructions.set("count", str(len(new_entries)))
                        if int(parent.returnInstructions.get("count")) != 0:
                            entries = parent.returnInstructions.text.split(",")
                            new_entries = []
                            for entry in entries:
                                if line_contained_in_region(entry, parent.get("startsAtLine"),
                                                            parent.get("endsAtLine")):
                                    new_entries.append(entry)
                            parent.returnInstructions._setText(",".join(new_entries))
                            parent.returnInstructions.set("count", str(len(new_entries)))

                        # add parent.id to parent_function.childrenNodes
                        parent_function = None
                        for tmp_node in parsed_cu.Node:
                            if tmp_node.get('type') == '1':
                                if line_contained_in_region(parent.get("startsAtLine"), tmp_node.get("startsAtLine"),
                                                            tmp_node.get("endsAtLine")):
                                    if line_contained_in_region(parent.get("endsAtLine"),
                                                                tmp_node.get("startsAtLine"),
                                                                tmp_node.get("endsAtLine")):
                                        parent_function = tmp_node
                                        break
                        if parent_function is None:
                            print("No parent function found for cu node: ", parent.get("id"), ". Ignoring.")
                        else:
                            parent_function.childrenNodes._setText(
                                parent_function.childrenNodes.text + "," + parent.get("id"))
                            if parent_function.childrenNodes.text.startswith(","):
                                parent_function.childrenNodes._setText(parent_function.childrenNodes.text[1:])

                        # Preprocessor Step 5 (looping)
                        parent_further_cn_entry = None
                        for cne_idx, calls_node_entry in enumerate(parent.callsNode):
                            # get first matching entry of node.callsNode
                            try:
                                for rc_idx, rec_call in enumerate(calls_node_entry.recursiveFunctionCall):
                                    rec_call_line = calls_node_entry.nodeCalled[rc_idx].get("atLine")
                                    if str(rec_call_line) in str(rec_call):
                                        parent_further_cn_entry = (rec_call, calls_node_entry.nodeCalled[rc_idx])
                                        break
                            except AttributeError:
                                continue
                        if parent_further_cn_entry is None:
                            # parent has no further recursive call, restart outer loop
                            inner_iteration = False
                            continue
                        else:
                            # parent still has recursive calls
                            inner_iteration = True
                            node = parent
                            remaining_recursive_call_in_parent = True
                            continue
                    else:
                        inner_iteration = False
                        continue
                else:
                    # node not of type CU, go to next node
                    inner_iteration = False
                    continue

        iterate_over_cus = False  # disable restarting, preprocessing finished

    # print modified Data.xml to file
    modified_cu_xml = cu_xml.replace(".xml", "-preprocessed.xml")
    if os.path.exists(modified_cu_xml):
        os.remove(modified_cu_xml)
    f = open(modified_cu_xml, "w+")
    f.write(etree.tostring(parsed_cu, pretty_print=True).decode("utf-8"))
    f.close()
    return modified_cu_xml


def __preprocessor_cu_contains_at_least_two_recursive_calls(node) -> bool:
    """Check if >= 2 recursive function calls are contained in a cu's code region.
    Returns True, if so.
    Returns False, else.
    :param node: CUNode
    :return: bool
    """
    starts_at_line = node.get("startsAtLine").split(":")
    ends_at_line = node.get("endsAtLine").split(":")
    file_id = starts_at_line[0]
    if file_id != ends_at_line[0]:
        raise Exception("error in Data.xml: FileIds of startsAtLine and endsAtLine not matching!")
    starts_at_line = starts_at_line[1]
    ends_at_line = ends_at_line[1]

    # count contained recursive Function calls
    contained_recursive_calls = 0
    for calls_node_entry in node.callsNode:
        try:
            for i in calls_node_entry.recursiveFunctionCall:
                rec_func_calls = [s for s in str(i).split(",") if len(s) > 0]
                if len(rec_func_calls) != 0:
                    for rec_func_call in rec_func_calls:
                        rec_func_call = rec_func_call.split(" ")[1]
                        rfc_file_id = rec_func_call.split(":")[0]
                        rfc_line = rec_func_call.split(":")[1]
                        # test if recursiveFunctionCall is inside CU region
                        if rfc_file_id == file_id and \
                                starts_at_line <= rfc_line <= ends_at_line:
                            contained_recursive_calls += 1
        except AttributeError:
            pass
    if contained_recursive_calls >= 2:
        return True
    return False


def check_loop_scopes(pet: PETGraphX):
    """Checks if the scope of loop CUs matches these of their children. Corrects the scope of the loop CU
    (expand only) if necessary
    :param pet: PET graph"""
    for loop_cu in pet.all_nodes(NodeType.LOOP):
        for child in pet.direct_children(loop_cu):
            if not line_contained_in_region(child.start_position(), loop_cu.start_position(), loop_cu.end_position()):
                # expand loop_cu start_position upwards
                if child.start_line < loop_cu.start_line and loop_cu.file_id == child.file_id:
                    loop_cu.start_line = child.start_line
            if not line_contained_in_region(child.end_position(), loop_cu.start_position(), loop_cu.end_position()):
                # expand loop_cu end_position downwards
                if child.end_line > loop_cu.end_line and loop_cu.file_id == child.file_id:
                    loop_cu.end_line = child.end_line
