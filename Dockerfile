FROM centos:7

LABEL maintainer="Jaeyoung Chun (chunj@mskcc.org)" \
      version.genrich="0.5" \
      source.genrich="https://github.com/jsh58/Genrich/releases/tag/v0.5"

ENV GENRICH_VERSION 0.5

# As of 2019-02-13
# Genrich v0.5 was successfully tested with GCC 5.4.0 and ZLIB 1.2.8
# We use 1.2.7 instead for centos7
ENV GCC_VERSION=5.4.0
ENV ZLIB_DEVEL_VERSION=1.2.7

RUN yum group install -y "Development Tools"
# RUN yum install -y wget

RUN cd /tmp \
    && curl https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.bz2 -O \
    && tar xvfj gcc-${GCC_VERSION}.tar.bz2 \
    && yum install gmp-devel mpfr-devel libmpc-devel -y \
    && mkdir gcc-${GCC_VERSION}-build \
    && cd gcc-${GCC_VERSION}-build \
    && ../gcc-${GCC_VERSION}/configure --enable-languages=c,c++ --disable-multilib \
    && make -j$(nproc) && make install

RUN yum install -y zlib-devel-${ZLIB_DEVEL_VERSION}

RUN cd /tmp \
    && curl https://github.com/jsh58/Genrich/archive/v${GENRICH_VERSION}.tar.gz -O -L \
    && tar xvzf v${GENRICH_VERSION}.tar.gz \
    && cd Genrich-${GENRICH_VERSION} \
    && make \
    && mv ./Genrich /usr/bin/

# ENTRYPOINT ["/bin/bash"]
ENTRYPOINT ["/usr/bin/Genrich"]
