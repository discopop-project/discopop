
class ExecutionResult(object):
    runtime: float
    return_code: int
    result_valid: bool

    def __init__(self, runtime: float,  return_code: int, result_valid: bool):
        self.runtime = runtime
        self.return_code = return_code
        self.result_valid = result_valid

    def __str__(self)->str:
        return "" + "time: " + str(self.runtime) + " code: " + str(self.return_code) + " valid: " + str(self.result_valid)
    