FROM ubuntu:20.04

ADD . /Docker

RUN mkdir -p /workspace/projects
  
WORKDIR /workspace/projects
ENV workspace=/workspace/projects
RUN mkdir -p riscv
ARG UID=1000
ARG GID=1000
ARG NAME=base
# set install path of tools about risc-v
ENV RISCV=/opt/riscv
ENV PATH=$PATH:$RISCV/bin
RUN mkdir -p ${RISCV} && mkdir -p ${RISCV}/bin

ENV INSTALLATION_TOOLS apt-utils \
    sudo \
    curl \
    wget \
    software-properties-common

ENV TOOL_PACKAGES dos2unix \
    git \
    nano \
    vim \
    tree \
    locales \
    python3-pip \
    make \
    build-essential \
    autoconf \
    automake \
    autotools-dev \
    curl \
    libmpc-dev \ 
    libmpfr-dev \
    libgmp-dev \
    gawk \
    bison \
    flex \
    texinfo \
    gperf \
    libtool \
    patchutils \
    bc \
    zlib1g-dev \
    libexpat-dev \
    ninja-build \
    device-tree-compiler


# install essential tools and packages
RUN apt-get update -qq && \
    apt-get install ${INSTALLATION_TOOLS} -yqq && \
    add-apt-repository ppa:git-core/ppa && \
    apt-get update -qq && \
    apt-get upgrade -yqq && \
    apt-get install ${TOOL_PACKAGES} -yqq

# Change time zone
RUN apt-get install -yqq --no-install-recommends tzdata
RUN TZ=Asia/Taipei \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN groupadd -g $GID -o $NAME

RUN useradd -u $UID -m -g $NAME -G plugdev $NAME && \ 
	echo "$NAME ALL = NOPASSWD: ALL" > /etc/sudoers.d/user && \
	chmod 0440 /etc/sudoers.d/user

RUN chown -R $NAME:$NAME /home/$NAME
RUN chown -R $NAME:$NAME /Docker

# Install required python modules
RUN pip3 install -r /Docker/requirements.txt


# install RISC-V GNU Toolchain

RUN mkdir -p /home/uscc_carl/riscv && cd /home/uscc_carl/riscv && \
    git clone https://github.com/riscv/riscv-gnu-toolchain.git && \
    cd riscv-gnu-toolchain && \  
    ./configure --prefix=$RISCV --enable-multilib && \
    sudo make linux -j $(nproc)

# add RISC-V GNU Toolchain to system search path

# install the RISC-V ISA simulator (Spike)
RUN cd /home/uscc_carl/riscv && \
    git clone https://github.com/riscv/riscv-isa-sim.git && \
    cd riscv-isa-sim && \
    mkdir -p build && \
    cd build && \
    ../configure --prefix=$RISCV && \
    make && \
    sudo make install

# install Proxy Kernel
RUN cd /home/uscc_carl/riscv && \ 
    git clone https://github.com/riscv/riscv-pk.git && \
    cd riscv-pk && \
    mkdir -p build && \
    cd build && \
    ../configure --prefix=$RISCV --host=riscv64-unknown-linux-gnu && \
    make && \
    sudo make install 

# Convert .sh files from CRLF to LF
RUN dos2unix -ic /Docker/start.sh | xargs dos2unix
RUN dos2unix -ic /Docker/env_setup.sh | xargs dos2unix

RUN cp /Docker/start.sh /usr/local/bin/ && chmod 755 /usr/local/bin/start.sh
USER $NAME
RUN echo eval /usr/local/bin/start.sh > ~/.bashrc 
RUN echo "export PS1=\"\[\e[0;31m\]\u@\[\e[m\e[0;34m\]\h\[\e[m \e[0;32m\] \w[\!]\$\[\e[m\]  \"" >> ~/.bashrc

# run bash
CMD ["/bin/bash"]

