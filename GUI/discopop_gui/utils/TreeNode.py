from typing import List, Dict, Any

class TreeNode:
    def __init__(self, id : int) -> None:
        self.id : int = id
        self.lower_order_connections : List["TreeNode"] = []
        self.higher_order_connections : List["TreeNode"] = []
        self.dependency_connections : List["TreeNode"] = []
        self.metadata : Dict[str, Any] = {}