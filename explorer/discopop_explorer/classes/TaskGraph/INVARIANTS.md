<!--
This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)

Copyright (c) 2020, Technische Universitaet Darmstadt, Germany

This software may be modified and distributed under the terms of
the 3-Clause BSD License.  See the LICENSE file in the package base
directory for details.
-->

# TaskGraph structural invariants

`TaskGraph` (`TaskGraph.py`) builds a single control-flow graph (`self.graph`, an
`nx.MultiDiGraph` of `TGNode`s) for the whole program, then runs a sequence of
passes in `__construct_from_pet` that progressively restructure it. Several of
these passes only produce correct results if the graph satisfies structural
invariants that are never fully validated at runtime - when one breaks, the
usual symptom is a confusing failure several passes later (e.g. a `ValueError`
in `__calculate_context_nesting`), far from the pass that actually violated it.
This document makes those invariants explicit.

## 1. Matched Start/End pairing

Every construct that can be "entered" - `TGStartFunctionNode`, `TGStartLoopNode`,
`TGStartIterationNode`, `TGStartBranchParentNode`, `TGStartBranchNode`,
`TGStartWorkNode`, `TGStartInlinedFunctionNode` - must have a corresponding
End-type node reachable on every forward path, and conversely **no End-type
node may be reachable without first passing through its Start counterpart** on
that same path.

`__calculate_context_nesting` implements this as a simple stack machine: it
does a BFS from every node with zero predecessors, pushing a context on Start
nodes and popping on End nodes. It has no recovery path if an End node is
encountered with an empty stack - that raises
`ValueError("Current context must not be None during processing!")` directly.
Concretely, this means: **a node with zero predecessors must never be an
End-type node** (see invariant 3).

## 2. Single-entry/single-exit (SESE) regions

Branch/loop/work/inlined-function wrapping is only valid if the wrapped region
has exactly one entry edge and one exit edge crossing its boundary.
`__add_branching_nodes_for_function`'s docstring states this explicitly:
dominance/post-dominance is used specifically to *guarantee* properly nested
SESE regions, because the context-nesting stack walk (invariant 1) only
produces one consistent enclosing context per node when the regions it walks
are properly nested. A purely local in/out-degree heuristic can instead wrap
unrelated, non-nested merge points into the same marker, which silently
corrupts context assignment depending on graph traversal order.

## 3. No zero-predecessor End-type / zero-successor Start-type nodes

This is implied by invariant 1, but is the one that actually gets violated in
practice and is worth stating on its own: no `TGEndBranchParentNode` (or any
other End-type node) may end up with zero predecessors, and no
`TGStartBranchParentNode` (or Start-type node) may end up with zero
successors. Such a node is either unreachable (harmless, but dead weight) or -
far more commonly - a node with **zero predecessors that IS reachable**
because it has zero predecessors globally, making it a bogus entry point for
invariant 1's BFS.

`__add_branching_nodes` validates this directly after `__add_branching_nodes_for_function`
and `__add_branching_nodes_fallback_cleanup` run (`TaskGraph.py`, the
"validating amounts of node successors and predecessors" loop), raising
`ValueError("Invalid graph structure!")` immediately if it's violated - turning
a would-be confusing crash deep in context nesting into an immediate, precisely
located one.

Two concrete ways this invariant used to break in `__add_branching_nodes_for_function`
(both fixed - see `test_TaskGraph.py`):

- **A branch point can dominate none of its merge point's current
  predecessors.** `m = ipdom(n)` only guarantees that all paths from `n`
  eventually reach `m` - not that `n` is the sole way to reach `m`. If `m` is
  also reachable from outside `n`'s subtree (e.g. two independent branches
  that happen to reconverge at the same point), `n` can end up dominating none
  of `m`'s current predecessors. Wrapping `n` anyway would create a
  `TGEndBranchParentNode` with zero predecessors. Fix: compute the claimed
  predecessor set before mutating anything, and skip wrapping `n` entirely
  (leaving it for `__add_branching_nodes_fallback_cleanup`, which is designed
  for exactly this case) if the claim is empty.
- **A branch point can be one of its own merge point's direct predecessors.**
  An "if" with no "else" has one arm going straight to the merge point `m`,
  so `n` trivially dominates itself and is included in the claimed-predecessor
  set computed from `m`. But the *next* step unconditionally retargets all of
  `n`'s own outgoing edges (including that direct arm to `m`) onto a freshly
  created `start_branch_parent_node`. By the time the claimed-predecessor loop
  runs, `(n, m)` no longer exists - only `(start_branch_parent_node, m)` does.
  Removing it a second time raises `nx.NetworkXError` and aborts the
  function's wrapping partway through, leaving whatever
  `TGEndBranchParentNode` was under construction behind with however many
  predecessors happened to be wired before the abort (possibly zero). Fix:
  substitute `start_branch_parent_node` for `n` when processing the claimed
  set, since that's the live stand-in for `n`'s own contribution after the
  rewiring above.

## 4. Acyclicity per function

`__break_cycles` and `__duplicate_loop_iterations` turn each function's
control-flow subgraph into a DAG before any pass that relies on it (dominance
for branching nodes, the context-nesting BFS) runs - loops are unrolled into
two linear copies instead of kept as back-edges. All later passes assume no
cycles remain; none of them re-check this.

## 5. `iteration_nodes` closure

Used by `__get_iteration_nodes` / `__copy_iteration_subgraph` /
`__fix_loop_structures`: a node belongs to "one iteration" iff it has a
forward path to the iteration's end node. Edges from a member of this set to a
non-member are expected to be pruned by `__fix_loop_structures` *before*
`__duplicate_loop_iterations` copies the set. If one slips through anyway,
`__copy_iteration_subgraph` silently drops it when copying (visible as a
`"could not draw edge ... due to a KeyError"` warning) rather than raising -
usually harmless in isolation, but the same "unvalidated invariant" pattern as
invariant 3, and a candidate root cause if a similar orphaned-node crash shows
up again elsewhere in construction.

## Where this bites in practice

All of the invariants above are enforced (or silently violated) inside
`__construct_from_pet`'s single linear pipeline. The passes run in this order,
and each one's correctness assumption depends on the previous ones having held:

```
__visit_pet -> __break_cycles -> __fix_loop_structures -> __duplicate_loop_iterations
  -> __validate_graph_structure (currently a no-op) -> __add_work_nodes
  -> __assign_loopstate_positions_within_functions -> __inline_function_calls
  -> __add_branching_nodes -> __assign_contexts -> __assign_node_levels
  -> __calculate_context_nesting -> __calculate_context_successions
```

When debugging a "malformed graph" failure, first identify *which* invariant
broke and on *which* node (the exception message and node label are usually
enough), then look at the pass responsible for maintaining that invariant
rather than the pass that happened to crash - by the time invariant 1 or 3
breaks, the actual mistake was usually made several passes earlier.
