# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from typing import List, Optional


class ExecutionResult(object):
    runtime: float
    return_code: int
    result_valid: bool
    thread_sanitizer: bool
    # True when at least one of the requested suggestions never reached the code. Such
    # a configuration is not a measurement of the suggestions it is labelled with --
    # it would be a measurement of the unmodified code -- so it is never executed and
    # must never be accepted as a search result.
    application_failed: bool
    failed_suggestions: List[int]

    def __init__(
        self,
        runtime: float,
        return_code: int,
        result_valid: bool,
        thread_sanitizer: bool,
        application_failed: bool = False,
        failed_suggestions: Optional[List[int]] = None,
    ):
        self.runtime = runtime
        self.return_code = return_code
        self.result_valid = result_valid
        self.thread_sanitizer = thread_sanitizer
        self.application_failed = application_failed
        self.failed_suggestions = [] if failed_suggestions is None else failed_suggestions

    def __str__(self) -> str:
        res = (
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
        if self.application_failed:
            res += " NOT APPLIED: " + str(self.failed_suggestions)
        return res
