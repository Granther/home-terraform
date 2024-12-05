terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

variable "token_id" {
  type = string
}

variable "token_secret" {
  type = string
}

provider "proxmox" {
 pm_api_url   = "https://192.168.1.172:8006/api2/json"
 pm_api_token_id = var.token_id
 pm_api_token_secret = var.token_secret
 pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "my_vm" {
 name       = "my-vm"
 target_node = "splinkus-pve"
 clone      = "ubuntu-lts-better-template"
# storage    = "splink-mirror"
 cores      = 2
 memory     = 2048
}
