# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

# Dockerfile for an image containing the dependencies of graph_analyzer

FROM tiagopeixoto/graph-tool
RUN pacman --noconfirm -S python-pip
COPY graph_analyzer/requirements.txt /requirements.txt
RUN pip install -r /requirements.txt
