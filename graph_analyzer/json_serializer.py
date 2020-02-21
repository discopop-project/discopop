from json import JSONEncoder

from pattern_detectors.PatternInfo import PatternInfo
from variable import Variable


def filter_members(d: dict) -> dict:
    """Removes private and protected members (which starts with '_')

    :param d: member dictionary
    :return: member dictionary
    """
    keys = [k for k in d.keys()]
    for key in keys:
        if key.startswith('_'):
            del d[key]
    return d


class PatternInfoSerializer(JSONEncoder):
    """Json Encoder for Pattern Info
    """
    def default(self, o):
        try:
            iterable = iter(o)
        except TypeError:
            pass
        else:
            return list(iterable)

        if isinstance(o, Variable):
            return o.name
        if isinstance(o, PatternInfo):
            return filter_members(o.__dict__)

        # Let the base class default method raise the TypeError
        return JSONEncoder.default(self, o)
