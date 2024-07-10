FROM rockylinux:9.3

# Set URLs for the packages
ENV X86_64_URL=https://dl.rockylinux.org/pub/rocky/9/CRB/x86_64/os/Packages/n/ninja-build-1.10.2-6.el9.x86_64.rpm
ENV AARCH64_URL=https://dl.rockylinux.org/pub/rocky/9/CRB/aarch64/os/Packages/n/ninja-build-1.10.2-6.el9.aarch64.rpm

# Conditional download and installation
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        curl -OL $X86_64_URL && \
        dnf install -y ./ninja-build-1.10.2-6.el9.x86_64.rpm && \
        rm -f ./ninja-build-1.10.2-6.el9.x86_64.rpm; \
    elif [ "$ARCH" = "aarch64" ]; then \
        curl -OL $AARCH64_URL && \
        dnf install -y ./ninja-build-1.10.2-6.el9.aarch64.rpm && \
        rm -f ./ninja-build-1.10.2-6.el9.aarch64.rpm; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi

RUN dnf makecache
# Install my shell
RUN dnf install -y zsh tmux git gcc-c++

# Install requirements for nvim build
WORKDIR /tmp

RUN dnf install -y cmake gcc make unzip gettext glibc-gconv-extra

RUN git clone --branch release-0.10 --single-branch https://github.com/neovim/neovim.git

WORKDIR /tmp/neovim
RUN make CMAKE_BUILD_TYPE=Release
RUN make install

# Create my user
RUN useradd -ms /usr/bin/zsh me
# Set workdir to my home directory
USER me
WORKDIR /home/me

# Install rust so that we can use rust tools
ENV PATH="/home/me/.cargo/bin:${PATH}"
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
RUN echo 'source ~/.cargo/env' >> /home/me/.bashrc

RUN cargo install eza
RUN cargo install ripgrep
