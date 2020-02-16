class Variable(object):
    def __init__(self, type, name):
        self.type = type
        self.name = name

    def __hash__(self):
        return hash(self.name)  # hash(self.type + self.name)

    def __eq__(self, other):
        return isinstance(other, Variable) and self.name == other.name  # and self.type == other.type
