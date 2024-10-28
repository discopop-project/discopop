# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.


class ExecutionResult(object):
    runtime: float
    return_code: int
    result_valid: bool
    thread_sanitizer: bool

    def __init__(self, runtime: float, return_code: int, result_valid: bool, thread_sanitizer: bool):
        self.runtime = runtime
        self.return_code = return_code
        self.result_valid = result_valid
        self.thread_sanitizer = thread_sanitizer

    def __str__(self) -> str:
        return (
            ""
            + "time: "
            + str(self.runtime)
            + " code: "
            + str(self.return_code)
            + " valid: "
            + str(self.result_valid)
            + " TSAN: "
            + str(self.thread_sanitizer)
        )
