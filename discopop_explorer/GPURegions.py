from numpy import long  # type: ignore
from typing import List, Set, Optional, cast
from .PETGraphX import PETGraphX, CUNode, NodeType, EdgeType, DepType
from .GPULoop import GPULoopPattern
from .GPUMemory import map_node
from .utils import is_loop_index2
from .variable import Variable


class GPURegions:
    cascadingLoopsInRegions: List[List[str]]
    gpu_loop_patterns: List[GPULoopPattern]
    loopsInRegion: List[str]
    pet: PETGraphX
    numRegions: int

    def __init__(self, pet, gpu_patterns):
        self.loopsInRegion = []
        self.gpu_loop_patterns = gpu_patterns
        self.cascadingLoopsInRegions = [[]]
        self.numRegions = 0
        self.pet = pet


    def findGPULoop(self, nodeID: str) -> Optional[GPULoopPattern]:
        """

        :param nodeID:
        :return:
        """
        for i in self.gpu_loop_patterns:
            if i.node_id == nodeID:
                return i
        return None

    def reachableCUs(self, cuID: str, nextCUID: str) -> bool:
        """

        :param cuID:
        :param nextCUID:
        :return:
        """
        loop: CUNode = map_node(self.pet, cuID)
        nextLoop: CUNode = map_node(self.pet, nextCUID)

        # next loop is not a loop!
        if nextLoop.type != 2:
            return False

        loopFirstChild: CUNode = self.pet.direct_children(loop)[0]
        CUIDsofLoop = self.pet.out_edges(loopFirstChild.id, EdgeType.SUCCESSOR)
        lastCUofLoop = map_node(self.pet, CUIDsofLoop[1][1])
        nextLoopFirstChild: CUNode = self.pet.direct_children(nextLoop)[0]
        successors = self.pet.out_edges(lastCUofLoop.id, EdgeType.SUCCESSOR)
        if successors:
            if nextLoopFirstChild.id == successors[0][1]:
                return True
            else:
                return False
        return False

    def identifyGPURegions(self) -> None:
        """

        :return:
        """
        regionNum = 0
        # find the next loop of each loop in the source code
        self.findNextLoop()

        self.cascadingLoopsInRegions[regionNum].append(
            self.gpu_loop_patterns[0].nodeID)
        for i in range(0, len(self.gpu_loop_patterns)):
            if self.gpu_loop_patterns[i].nextLoop:
                if map_node(self.pet, self.gpu_loop_patterns[i].nextLoop).type == 2:
                    if self.reachableCUs(self.gpu_loop_patterns[i].nodeID, self.gpu_loop_patterns[i].nextLoop):
                        self.cascadingLoopsInRegions[regionNum].append(
                            self.gpu_loop_patterns[i].nextLoop)
                    else:
                        regionNum += 1
                        self.cascadingLoopsInRegions.append([])
                        self.cascadingLoopsInRegions[regionNum].append(
                            self.gpu_loop_patterns[i].nextLoop)

        self.numRegions = regionNum + 1

    def determineDataMapping(self) -> None:
        """determine data mapping for each GPU Region and their contained GPU Loops."""

        for region in self.cascadingLoopsInRegions:
            print("GPU Region:", region)
            # determine CUs which belong to the region (= which are located inside the region)
            region_cus: List[CUNode] = []
            for loop_id in region:
                loop_node: CUNode = self.pet.node_at(loop_id)
                gpu_lp: GPULoopPattern = [p for p in self.gpu_loop_patterns if p.parentLoop == loop_id][0]
                region_cus += [cu for cu in self.pet.subtree_of_type(loop_node, None) if cu not in region_cus]
            # determine start and end line of region
            region_start_line = min([cu.start_line for cu in region_cus])
            region_end_line = max([cu.end_line for cu in region_cus])


            # determine variables which are written outside the region and read inside
            consumed_vars: List[str] = []
            for cu in region_cus:
                in_dep_edges = self.pet.out_edges(cu.id, EdgeType.DATA)
                # var is consumed, if incoming RAW dep exists
                for sink_cu_id, source_cu_id, dep in in_dep_edges:
                    # unpack dep for sake of clarity
                    sink_line = dep.sink
                    source_line = dep.source
                    var_name = dep.var_name
                    if self.pet.node_at(source_cu_id) not in region_cus:
                        if dep.dtype == DepType.RAW:
                            if dep.var_name not in consumed_vars:
                                consumed_vars.append(dep.var_name)
            print("Consumed vars: ", consumed_vars)

            # determine variables which are read afterwards and written in the region
            produced_vars: List[str] = []
            for cu in region_cus:
                out_dep_edges = self.pet.in_edges(cu.id, EdgeType.DATA)
                # var is produced, if outgoing RAW or WAW dep exists
                for sink_cu_id, source_cu_id, dep in out_dep_edges:
                    # unpack dep for sake of clarity
                    sink_line = dep.sink
                    source_line = dep.source
                    var_name = dep.var_name
                    if self.pet.node_at(sink_cu_id) not in region_cus:
                        if dep.dtype in [DepType.RAW, DepType.WAW]:
                            if dep.var_name not in produced_vars:
                                produced_vars.append(dep.var_name)
            print("Produced vars: ", produced_vars)


    def old_mapData(self) -> None:
        """
        :return:
        """

        for i in range(0, self.numRegions):
            for j in self.cascadingLoopsInRegions[i]:
                tmp_result = self.findGPULoop(j)
                if tmp_result is None:
                    continue
                gpuLoop: GPULoopPattern = cast(GPULoopPattern, tmp_result)
                gpuLoop.printGPULoop()
        print(f"==============================================")
        for i in range(0, self.numRegions):
            t: int = len(self.cascadingLoopsInRegions[i]) - 1
            firstNodeID = self.cascadingLoopsInRegions[i][0]
            lastNodeID = self.cascadingLoopsInRegions[i][t]
            fn = map_node(self.pet, firstNodeID)
            ln = map_node(self.pet, lastNodeID)
            start = fn.start_line
            end = ln.end_line
            gpuRegionLoop = GPULoopPattern(
                self.pet, firstNodeID, start, end, 1000)
            visitedVars: Set[Variable] = set()
            while t >= 0:
                tmp_result = self.findGPULoop(
                    self.cascadingLoopsInRegions[i][t])  # tmp_result contains GPU loops inside the parent region

                if tmp_result is None:
                    t -= 1
                    continue

                loopIter: GPULoopPattern = cast(GPULoopPattern, tmp_result)
                varis: Set[Variable] = set([])
                varis.update(loopIter.map_type_alloc)
                varis.update(loopIter.map_type_to)
                varis.update(loopIter.map_type_from)
                varis.update(loopIter.map_type_tofrom)
                # loopIter.printGPULoop()
                for v in varis:
                    if loopIter.findMappedVar("from", v):
                        if v in visitedVars:
                            if gpuRegionLoop.findMappedVar("to", v):
                                # // cout << "gpuRegionLoop to: " << get_var_name(v) << endl;
                                gpuRegionLoop.map_type_to.remove(v)
                                # gpuRegionLoop.map_type_to.erase(remove(gpuRegionLoop.map_type_to.begin(),
                                #                                       gpuRegionLoop.map_type_to.end(), v),
                                #                                gpuRegionLoop.map_type_to.end())
                                gpuRegionLoop.map_type_alloc.append(v)
                                visitedVars.add(v)
                            else:
                                gpuRegionLoop.map_type_from.append(v)
                                visitedVars.add(v)
                        else:
                            # // cout << "visited from: " << get_var_name(v) << endl;
                            gpuRegionLoop.map_type_from.append(v)
                            visitedVars.add(v)
                    elif loopIter.findMappedVar("to", v):
                        if v in visitedVars:
                            # // cout << "loopIter to: " << get_var_name(v) << endl;
                            if gpuRegionLoop.findMappedVar("alloc", v):
                                # // cout << "gpuRegionLoop alloc: " << get_var_name(v) << endl;
                                gpuRegionLoop.map_type_alloc.remove(v)

                                gpuRegionLoop.map_type_to.append(v)
                                visitedVars.add(v)
                        else:
                            # // cout << "visited to: " << get_var_name(v) << endl;
                            gpuRegionLoop.map_type_to.append(v)
                            visitedVars.add(v)
                    elif loopIter.findMappedVar("tofrom", v):
                        if v not in visitedVars:
                            # // cout << "loopIter tofrom: " << get_var_name(v) << endl;
                            gpuRegionLoop.map_type_tofrom.append(v)
                            visitedVars.add(v)
                        else:
                            if gpuRegionLoop.findMappedVar("to", v):
                                gpuRegionLoop.map_type_to.remove(v)
                                gpuRegionLoop.map_type_alloc.append(v)
                            elif gpuRegionLoop.findMappedVar("from", v):
                                gpuRegionLoop.map_type_from.remove(v)
                                gpuRegionLoop.map_type_tofrom.append(v)
                    elif loopIter.findMappedVar("alloc", v):
                        if v not in visitedVars:
                            gpuRegionLoop.map_type_alloc.append(v)
                            visitedVars.add(v)
                t -= 1

            # gpuRegionLoop.printGPULoop()  # only prints first loop of the region.
                                            # first loop of the region is used to store the map_to behavior
                                            # last loop if the region should be used to store the map_from behavior

    def findNextLoop(self) -> None:
        """

        :return:
        """

        i: int = 0
        while i < len(self.gpu_loop_patterns):
            skip: int = i
            for k in self.gpu_loop_patterns[skip].nestedLoops:
                """ To find the next loop for a loop,
                    we need to skip over the nested loops in the identified GPU loops.
                    Also, some loops may not be do-all or reduction
                    and not listed in the gpu_loop_patterns. We need to skip them
                    Create a dummy GPULoopPattern and
                    search for the gpu loops with the same NodeID
                """
                dd = GPULoopPattern(self.pet, k,
                                    self.gpu_loop_patterns[skip].start_line,
                                    self.gpu_loop_patterns[skip].end_line,
                                    self.gpu_loop_patterns[skip].iteration_count)
                for ii in self.gpu_loop_patterns:
                    if dd.nodeID == ii.nodeID:  # TODO: check remaining attributes too
                        i += 1

            if (i + 1) < len(self.gpu_loop_patterns):
                self.gpu_loop_patterns[skip].nextLoop = self.gpu_loop_patterns[i + 1].node_id

            i += 1

    def getParentLoop(self, node: CUNode) -> bool:
        """

        :param node:
        :return:
        """
        main: CUNode = self.pet.main
        path: List[CUNode] = self.pet.path(map_node(self.pet, main.id), node)
        path.reverse()

        for parent in path:
            if not parent.id == node.id and parent.type == NodeType.LOOP:
                return True
        return False
