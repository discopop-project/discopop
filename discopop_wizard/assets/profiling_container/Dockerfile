# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.

FROM ubuntu:22.04

ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get install -y git cmake gcc libclang-11-dev clang-11 llvm-11 clang-tools-11 python3 python3-pip python3-tk wget file

# clone DiscoPoP
#RUN git clone https://github.com/discopop-project/discopop.git
RUN git clone https://github.com/SenseiEnrique/discopop_extended_CUs
WORKDIR /discopop

# install DiscoPoP
RUN mkdir build
WORKDIR /discopop/build
RUN cmake ..
RUN make
WORKDIR /discopop

# install GO
WORKDIR /
RUN mkdir software
WORKDIR /software
RUN wget https://dl.google.com/go/go1.16.15.linux-amd64.tar.gz
RUN tar -xvf *
RUN rm *.tar.gz
RUN ln -s /software/go/bin/go /usr/bin/go

# install GLLVM
WORKDIR /
RUN GOPATH=/software/go/bin GO111MODULE=off go get github.com/SRI-CSL/gllvm/cmd/...
WORKDIR /software/go/bin
RUN mv bin/* .
RUN mv src/* ../src

# install python dependencies and modules
WORKDIR /discopop
RUN pip install .
