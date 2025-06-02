#!/bin/bash

# Define an array of the Go tools to be installed.
tools=(
  "mvdan.cc/gofumpt@latest"
  "golang.org/x/tools/cmd/callgraph@latest"
  "github.com/golang/mock/mockgen@latest"
  "github.com/murphysec/go-tools/cmd/iferr@latest"
  "github.com/segmentio/golines@latest"
  "github.com/abice/go-enum@latest"
  "github.com/golangci/golangci-lint/cmd/golangci-lint@latest"
  "github.com/ChimeraCoder/gojson/gojson@latest"
  "github.com/josharian/impl@latest"
  "github.com/fatih/gomodifytags@latest"
  "github.com/go-delve/delve/cmd/dlv@latest"
  "github.com/davidrjenni/reftools/cmd/fillswitch@latest"
  "github.com/bxcodec/faker/cmd/gojsonstruct@latest"
  "golang.org/x/tools/gopls@latest"
  "github.com/kyoh86/richgo@latest"
  "github.com/onsi/ginkgo/v2/ginkgo@latest"
  "gotest.tools/gotestsum@latest"
)

# Install each tool if it's not already available in GOPATH/bin.
for tool in "${tools[@]}"; do
  tool_name="${tool##*/}"
  tool_exec="${tool_name%@*}"

  if ! command -v "$tool_exec" &> /dev/null; then
    echo "Installing $tool_exec..."
    go install "$tool"
  else
    echo "$tool_exec is already installed"
  fi
done

echo "All specified Go tools are installed."

