FROM ubuntu:18.04
RUN apt-get update
RUN apt-get install -y \
  curl \
  g++ \
  gcc \
  libgmp-dev \
  libtinfo-dev \
  make \
  ncurses-dev \
  python3 \
  libnuma-dev \
  coreutils

RUN curl https://get-ghcup.haskell.org -sSf | sh

ENV PATH ~/.cabal/bin:/root/.ghcup/bin:$PATH
RUN echo "source /root/.ghcup/env" >> ~/.bashrc

RUN cabal v2-update
RUN cabal v2-install --global --lib \
  mwc-random-0.14.0.0 \
  vector-algorithms-0.8.0.1