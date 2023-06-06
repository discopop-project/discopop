from typing import Dict

from discopop_library.discopop_optimizer.CostModels.CostModel import CostModel
from discopop_library.discopop_optimizer.classes.context.ContextObject import ContextObject


class CodeStorageObject(object):
    cost_model: CostModel
    modified_code: Dict[int, str]

    def __init__(self, cost_model: CostModel, modified_code: Dict[int, str]):
        self.cost_model = cost_model
        self.modified_code = modified_code
