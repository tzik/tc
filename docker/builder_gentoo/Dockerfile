# syntax=docker/dockerfile:experimental

FROM gentoo/portage AS portage
FROM gentoo/stage3
COPY make.conf /etc/portage/make.conf
RUN --mount=type=cache,target=/var/cache/distfiles --mount=type=cache,target=/var/cache/binpkgs \
    --mount=type=bind,from=portage,source=/var/db/repos/gentoo,target=/var/db/repos/gentoo \
    emerge -vDNu world \
      dev-cpp/catch \
      dev-cpp/glog \
      dev-libs/protobuf \
      dev-python/pybind11 \
      dev-python/pyyaml \
      dev-util/ccache \
      dev-util/cmake \
      dev-util/ninja \
      dev-util/pkgconfig \
      dev-vcs/git \
      sys-devel/clang \
      && :
