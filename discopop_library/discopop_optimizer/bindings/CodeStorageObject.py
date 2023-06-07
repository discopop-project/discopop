from typing import Dict

from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.classes.context.ContextObject import ContextObject
from discopop_library.discopop_optimizer.classes.nodes.FunctionRoot import FunctionRoot


class CodeStorageObject(object):
    cost_model: CostModel
    patches: Dict[int, str]
    parent_function: FunctionRoot

    def __init__(
        self, cost_model: CostModel, patches: Dict[int, str], parent_function: FunctionRoot
    ):
        self.cost_model = cost_model
        self.patches = patches
        self.parent_function = parent_function
