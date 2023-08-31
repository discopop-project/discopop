# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

from sympy import Expr, Integer


def convert_discopop_to_microbench_workload(discopop_workload: Expr, iteration_count: Expr) -> Expr:
    """Converts the estimated workload into the workload measurement used by Microbench.
    According to Formula:

    Wm = ((Wd/iD)-w0)/(iD*wi) with

    Wm = Microbench workload
    Wd = DiscoPoP workload
    iD = iteration count
    w0 = 13, initialization workload for inner loops
    wi = 14, observed workload added by a single iteration of the inner loop according to DiscoPoP's workload definition

    returns: Wm

    source: Bertins Thesis: TODO
    """
    # todo
    w0 = 13
    wi = 14
    return ((discopop_workload / iteration_count) - w0) / (iteration_count * wi)


def convert_microbench_to_discopop_workload(
    microbench_workload: Expr, iteration_count: Expr
) -> Expr:
    """Converts the estimated workload into the workload measurement used by DiscoPoP.
    According to Formula:

    Wd = iD(Wm * iD * wi + w0) with

    Wm = Microbench workload
    Wd = DiscoPoP workload
    iD = iteration count
    w0 = 13, initialization workload for inner loops
    wi = 14, observed workload added by a single iteration of the inner loop according to DiscoPoP's workload definition

    returns: Wd

    source: Bertins Thesis: TODO
    """
    wi = Integer(14)
    w0 = Integer(13)

    return iteration_count * (microbench_workload * iteration_count * wi + w0)
