# syntax=docker/dockerfile:experimental
FROM ubuntu:rolling
RUN rm -f /etc/apt/apt.conf.d/docker-clean && \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
    apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    apt-get update && \
    apt-get -y --no-install-recommends install \
      catch2 \
      ccache \
      clang \
      clang-format \
      cmake \
      flex \
      g++ \
      git \
      libgmp-dev \
      libgoogle-glog-dev \
      libmpc-dev \
      libmpfr-dev \
      libprotobuf-dev \
      make \
      ninja-build \
      patch \
      pkg-config \
      protobuf-compiler \
      pybind11-dev \
      python3 \
      python3-dev \
      python3-pip \
      python3-setuptools \
      python3-yaml \
      xz-utils \
      && :
RUN update-alternatives --install /usr/bin/python python "$(which python3)" 1
