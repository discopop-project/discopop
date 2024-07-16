
class ExecutionResult(object):
    runtime: float
    return_code: int
    result_valid: bool

    def __init__(self, runtime: float,  return_code: int, result_valid: bool):
        self.runtime = runtime
        self.return_code = return_code
        self.result_valid = result_valid