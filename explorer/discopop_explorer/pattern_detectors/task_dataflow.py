# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
"""Data flow of a group of tasks: the dependences between the tasks, what the code after the group depends on, and the
data sharing of the variables of the tasks.

The information comes from the dependences registered on the contexts of the TaskGraph (the ContextTaskGraph drops
them while it is simplified): ``Context.outgoing_dependencies`` holds ``(source context, dependence)`` for a context
that is the sink, the later access, of the dependence. Only RAW and WAR are registered on contexts.

The variable types are not used: with opaque pointers they carry no information. A variable is classified by how the
tasks and the code after them access it (``classify_variable``).
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Dict, List, Optional, Set, Tuple

from discopop_explorer.classes.PEGraph.PEGraphX import PEGraphX
from discopop_explorer.classes.PEGraph.Dependency import Dependency
from discopop_explorer.classes.TaskGraph.Contexts.Context import Context
from discopop_explorer.enums.DepType import DepType

# the kinds of dependences registered on contexts, and what an access in the earlier task is
_KINDS = {DepType.RAW: "RAW", DepType.WAR: "WAR"}


@dataclass(frozen=True)
class TaskDependence:
    """A later task depends on an earlier one: ``kind`` RAW (the later reads what the earlier wrote) or WAR (the
    later writes what the earlier read)."""

    from_task: int
    to_task: int
    variable: str
    kind: str


@dataclass(frozen=True)
class AfterDependence:
    """The code after the group depends on a task: it reads what the task wrote (RAW) or writes what it read (WAR).
    ``line`` is the first line (file id:line) of the code after the group that does so."""

    task: int
    variable: str
    kind: str
    line: Optional[str]


@dataclass
class Sharing:
    shared: List[str] = field(default_factory=list)
    private: List[str] = field(default_factory=list)
    first_private: List[str] = field(default_factory=list)


@dataclass
class GroupDataflow:
    dependences: List[TaskDependence] = field(default_factory=list)
    after: List[AfterDependence] = field(default_factory=list)
    sharing: List[Sharing] = field(default_factory=list)


def _contexts_of(task: Context) -> Set[Context]:
    return {task} | task.get_contained_contexts(inclusive=True)


def _kind(dependence: Dependency) -> Optional[str]:
    return _KINDS.get(dependence.dtype) if dependence.dtype is not None else None


def _line_of_sink(pet: PEGraphX, dependence: Dependency) -> Optional[str]:
    if dependence.sink_instruction_id is not None:
        lines = pet.get_line_ids_of_instructions([dependence.sink_instruction_id])
        if lines:
            return str(lines[0])
    return str(dependence.sink_line) if dependence.sink_line else None


def _line_number(line: str) -> int:
    return int(line.split(":")[1])


def _dependences_between(task_contexts: List[Set[Context]]) -> List[TaskDependence]:
    found: Dict[Tuple[int, int, str, str], TaskDependence] = {}
    for later, later_contexts in enumerate(task_contexts):
        for context in later_contexts:
            for source_context, dependence in context.outgoing_dependencies:
                kind = _kind(dependence)
                if kind is None or dependence.var_name is None:
                    continue
                for earlier, earlier_contexts in enumerate(task_contexts):
                    if earlier != later and source_context in earlier_contexts:
                        key = (earlier, later, dependence.var_name, kind)
                        found[key] = TaskDependence(earlier, later, dependence.var_name, kind)
    return sorted(found.values(), key=lambda d: (d.from_task, d.to_task, d.variable, d.kind))


def _dependences_after(
    pet: PEGraphX, task_contexts: List[Set[Context]], after_contexts: Set[Context]
) -> List[AfterDependence]:
    first_line: Dict[Tuple[int, str, str], Optional[str]] = {}
    for task, contexts in enumerate(task_contexts):
        for context in contexts:
            for later_context, dependence in context.incoming_dependencies:
                kind = _kind(dependence)
                if later_context not in after_contexts or kind is None or dependence.var_name is None:
                    continue
                key = (task, dependence.var_name, kind)
                line = _line_of_sink(pet, dependence)
                known = first_line.get(key)
                if key not in first_line or (
                    line is not None and (known is None or _line_number(line) < _line_number(known))
                ):
                    first_line[key] = line
    return [AfterDependence(task, variable, kind, line) for (task, variable, kind), line in sorted(first_line.items())]


def _accessed_variables(pet: PEGraphX, task: Context) -> Dict[str, Tuple[bool, bool, str]]:
    """``name -> (read, written, defLine)`` of the variables the CUs of the task access."""
    accessed: Dict[str, Tuple[bool, bool, str]] = {}
    for tg_node in task.get_contained_nodes(inclusive=True):
        node = tg_node.get_pet_node(pet)
        for variable in list(getattr(node, "local_vars", [])) + list(getattr(node, "global_vars", [])):
            read, written, _ = accessed.get(variable.name, (False, False, variable.defLine))
            accessed[variable.name] = (
                read or "R" in variable.accessMode,
                written or "W" in variable.accessMode,
                variable.defLine,
            )
    return accessed


def classify_variable(
    read: bool,
    written: bool,
    declared_in_task: bool,
    global_variable: bool,
    written_by_sibling: bool,
    needed_after: bool,
) -> Optional[str]:
    """The data sharing of a variable of a task: ``shared``, ``private``, ``first_private``, or None if the task does
    not access it.

    - declared in the task: private, unless the code after the group needs its value (shared; the declaration has to
      move out of the task),
    - a global variable or one that is written by the task or by a sibling task: shared,
    - otherwise it is only read: first_private (the task works on the value at its creation).
    """
    if not read and not written:
        return None
    if declared_in_task:
        return "shared" if needed_after else "private"
    if global_variable or written or written_by_sibling:
        return "shared"
    return "first_private"


def _sharing(
    pet: PEGraphX,
    tasks: List[Context],
    task_lines: List[Tuple[int, int, int]],
    dependences: List[TaskDependence],
    after: List[AfterDependence],
) -> List[Sharing]:
    accessed = [_accessed_variables(pet, task) for task in tasks]
    result: List[Sharing] = []
    for index, variables in enumerate(accessed):
        sharing = Sharing()
        file_id, first, last = task_lines[index]
        for name, (read, written, def_line) in sorted(variables.items()):
            global_variable = def_line == "GlobalVar"
            declared = False
            if not global_variable and ":" in def_line:
                declared = int(def_line.split(":")[0]) == file_id and first <= _line_number(def_line) <= last
            by_sibling = any(
                other != index and variables_of_other[name][1]
                for other, variables_of_other in enumerate(accessed)
                if name in variables_of_other
            )
            needed_after = any(a.task == index and a.variable == name for a in after)
            kind = classify_variable(read, written, declared, global_variable, by_sibling, needed_after)
            if kind == "shared":
                sharing.shared.append(name)
            elif kind == "private":
                sharing.private.append(name)
            elif kind == "first_private":
                sharing.first_private.append(name)
        result.append(sharing)
    return result


def analyze_task_group(pet: PEGraphX, tasks: List[Context], task_lines: List[Tuple[int, int, int]]) -> GroupDataflow:
    """The data flow of the tasks of a group, in program order.

    ``task_lines``: ``(file id, first line, last line)`` of each task, to tell the variables declared in a task."""
    task_contexts = [_contexts_of(task) for task in tasks]
    inside: Set[Context] = set().union(*task_contexts) if task_contexts else set()
    after_contexts: Set[Context] = set()
    for task in tasks:
        after_contexts |= task.get_successive_contexts()
    after_contexts -= inside
    dependences = _dependences_between(task_contexts)
    after = _dependences_after(pet, task_contexts, after_contexts)
    return GroupDataflow(dependences, after, _sharing(pet, tasks, task_lines, dependences, after))


def clauses_of_dependences(dependences: List[TaskDependence], task: int) -> Tuple[List[str], List[str], List[str]]:
    """The ``in``, ``out`` and ``in/out`` variables of a task, as the OpenMP depend clauses would list them: the
    earlier access of a RAW is an out, the later an in; of a WAR, the earlier is an in and the later an out."""
    ins: Set[str] = set()
    outs: Set[str] = set()
    for dependence in dependences:
        earlier_writes = dependence.kind == "RAW"
        if dependence.from_task == task:
            (outs if earlier_writes else ins).add(dependence.variable)
        if dependence.to_task == task:
            (ins if earlier_writes else outs).add(dependence.variable)
    both = ins & outs
    return sorted(ins - both), sorted(outs - both), sorted(both)


__all__: Tuple[str, ...] = (
    "AfterDependence",
    "GroupDataflow",
    "Sharing",
    "TaskDependence",
    "analyze_task_group",
    "classify_variable",
    "clauses_of_dependences",
)
