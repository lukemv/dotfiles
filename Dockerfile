FROM rockylinux:9.3
RUN dnf makecache
# Install my shell
RUN dnf install -y zsh tmux git gcc-c++

# Create my user
RUN useradd -ms /usr/bin/zsh me
# Set workdir to my home directory 
USER me
WORKDIR /home/me

ENV PATH="/home/me/.cargo/bin:${PATH}"
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
RUN echo 'source ~/.cargo/env' >> /home/me/.bashrc

RUN cargo install eza

