FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y git cmake gcc libclang-11-dev clang-11 llvm-11 clang-tools-11 python3 python3-pip wget file

# clone DiscoPoP
RUN git clone https://github.com/discopop-project/discopop.git
WORKDIR /discopop

# install DiscoPoP
RUN mkdir build
WORKDIR /discopop/build
RUN cmake ..
RUN make
RUN ls
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
