class GenericNode(object):
    node_id: int  # id of the node in the nx.DiGraph which stores this object

    def __init__(self, node_id: int):
        self.node_id = node_id

    def get_plot_label(self) -> str:
        return ""
