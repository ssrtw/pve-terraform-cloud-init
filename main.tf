locals {
  tmpldir = "template"
  config = yamldecode(file("config.yml"))
}

terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

provider "proxmox" {
  endpoint  = local.config.endpoint
  api_token = local.config.api_token

  insecure = true

  ssh {
    username    = "root"
    private_key = file(local.config.ssh_private_key_path)
  }
}
