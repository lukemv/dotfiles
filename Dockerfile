FROM golang:1.20.3-buster

RUN apt update && apt install -y zsh
RUN useradd -ms /usr/bin/zsh me

WORKDIR /home/me
USER me

COPY .  .
RUN ./install.sh

WORKDIR /home/me/tests
RUN go get
RUN go test -v ./...
