
FROM swift AS build

USER gitpod
FROM gitpod/workspace-full
COPY --from=build /usr/bin/swiftc /usr/bin/

# Install Swift dependencies
RUN sudo apt-get update -q && \
    sudo apt-get install -yq libtinfo5 \
        libcurl4-openssl-dev \
        libncurses5 \
        libpython2.7 \
        libatomic1 \
        libcurl4 \
        libxml2 \
        libedit2 \
        libsqlite3-0 \
        libc6-dev \
        binutils \
        libpython2.7 \
        tzdata \
        git \
        pkg-config \
    && sudo rm -rf /var/lib/apt/lists/*

# Install Swift
RUN mkdir -p /home/gitpod/.swift && \
    cd /home/gitpod/.swift && \
    curl -fsSL https://swift.org/builds/swift-5.2-release/ubuntu1804/swift-5.2-RELEASE/swift-5.2-RELEASE-ubuntu18.04.tar.gz | tar -xzv
ENV PATH="$PATH:/home/gitpod/.swift/swift-5.2-RELEASE-ubuntu18.04/usr/bin"

# Install  jakeheis / Ice
RUN mkdir -p $HOME/ice && git clone https://github.com/jakeheis/Ice $HOME/ice
WORKDIR $HOME/ice
RUN swift build -c release
RUN sudo cp -f $HOME/ice/.build/release/ice /usr/local/bin

ARG USERNAME=me
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# try sourcekit-lsp
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    && apt-get -y install git openssh-client less iproute2 procps lsb-release \
    && apt-get install libsqlite3-0 libsqlite3-dev libtinfo-dev libncurses5-dev libncursesw5-dev  \
    && git clone https://github.com/apple/sourcekit-lsp.git \
    && cd sourcekit-lsp \
    && export PATH="/usr/bin:${PATH}"   \
    && swift package update \
    && swift build -Xcxx -I/usr/lib/swift -Xcxx -I/usr/lib/swift/Block  \
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*