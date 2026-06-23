# Terraform playground — terraform-ls (LSP) + terraform_fmt + treesitter (hcl).
#
# To get full provider-aware completion:
#   1. cd into this dir and run `terraform init` (downloads the libvirt provider).
#   2. Reopen this file; terraform-ls reads the provider schema.
#   3. Start typing `resource "libvirt_` to complete every libvirt resource,
#      and inside a block, complete/​hover every argument. prefillRequiredFields
#      auto-inserts required args when you accept a resource.

terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

# Configure the Libvirt Provider
provider "libvirt" {
  # Connection URI - defaults to qemu:///system if not specified
  # uri = "qemu:///system"

  # For user session:
  # uri = "qemu:///session"

  # For remote connections (not yet implemented):
  # uri = "qemu+ssh://user@remote-host/system"
}

# Try adding a resource below, e.g. start typing:  resource "libvirt_
