# This file is part of the DiscoPoP software (http://www.discopop.tu-darmstadt.de)
#
# Copyright (c) 2020, Technische Universitaet Darmstadt, Germany
#
# This software may be modified and distributed under the terms of
# the 3-Clause BSD License.  See the LICENSE file in the package base
# directory for details.
FROM ubuntu:latest
WORKDIR /usr/local/ci

RUN echo "PWD: "
RUN pwd
RUN ls

# update container
RUN apt-get update
RUN apt-get install build-essential
RUN apt-get install -y wget

# Install the application dependencies
RUN wget https://github.com/llvm/llvm-project/releases/download/llvmorg-11.1.0/clang+llvm-11.1.0-x86_64-linux-gnu-ubuntu-20.10.tar.xz
RUN tar -xvf clang+llvm-11.1.0-x86_64-linux-gnu-ubuntu-20.10.tar.xz
RUN mv clang+llvm-11.1.0-x86_64-linux-gnu-ubuntu-20.10 llvm-11.1.0
RUN rm clang+llvm-11.1.0-x86_64-linux-gnu-ubuntu-20.10.tar.xz
