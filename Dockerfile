
# Pull base image
FROM resin/rpi-raspbian:jessie
MAINTAINER Dieter Reuter <dieter@hypriot.com>

# update and wget
RUN apt-get -qq update && \
    apt-get -qqy install wget && \
    apt-get -qqy install bison ed gawk gcc libc6-dev make
	

RUN wget --no-check-certificate https://storage.googleapis.com/golang/go1.4.3.src.tar.gz && \
    tar zxvf go1.4.3.src.tar.gz && \
    rm go1.4.3.src.tar.gz && \
    mv go opt/go1.4.3

WORKDIR /opt/go1.4.3/src
RUN ./make.bash


ENV GO_VERSION=1.5.2
# Install go 1.6.2

WORKDIR /opt
RUN wget --no-check-certificate https://storage.googleapis.com/golang/go$GO_VERSION.src.tar.gz && \
    tar zxvf go$GO_VERSION.src.tar.gz && \
    rm go$GO_VERSION.src.tar.gz
WORKDIR /opt/go/src
RUN GOROOT_BOOTSTRAP=/opt/go1.4.3 GOOS=linux GOARCH=arm GOARM=7 ./make.bash
WORKDIR /opt
RUN rm -rf go1.4.3

# env variables
RUN mkdir /go
ENV GOROOT /opt/go
ENV GOPATH /go
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

RUN apt-get update && \
    apt-get -y install git-core

# Define default command
CMD ["bash"]
