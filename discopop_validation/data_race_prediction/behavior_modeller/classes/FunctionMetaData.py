class FunctionMetaData:
    name: str
    file_name: str
    function_entry_bb: int

    # stores meta data regarding a function and points to it's root BB node
    def __init__(self, fn_name):
        self.name = fn_name
