terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

provider "proxmox" {
 pm_api_url   = var.pm_api_url
 pm_api_token_id = var.token_id
 pm_api_token_secret = var.token_secret
 pm_tls_insecure = true
}

# resource "proxmox_vm_qemu" "k8s-lb-test" {
#  name       = "k8s-lb-test"
#  target_node = "splinkus-pve"
#  clone      = "ubuntu-lts-24-04-template"
# #  vm_state = "stopped"
#  cpu_type = "host"
#  cores      = 2
#  memory     = 2048
#  vga {
#   type = "std"
#  }

#   os_type   = "cloud-init"

#   # CLoud init settings
#   ipconfig0 = "ip=192.168.5.40/24,gw=192.168.5.1"
#   ciuser = "grant"
#   cipassword = "NA"
#   sshkeys = "NA"

#   disks {
#     scsi {
#       scsi0 {
#         disk {
#           storage = "local" #mine is local, yours to be local-lvm
#           size    = 32
#         }
#       }
#     }
#   }
# }


resource "proxmox_vm_qemu" "k8s-lb-test" {
  name = "k8s-lb-test"
  target_node = "splinkus-pve"
  clone = "ubuntu-lts-24-04-template"
  
  # Explicitly set cloud-init configuration
  clone_wait = 10  # Wait time for clone to complete
  
  # Cloud-init specific configurations
  os_type = "cloud-init"
  
  # Network configuration
  ipconfig0 = "ip=192.168.5.40/24,gw=192.168.5.1"
  
  # User configuration
  ciuser = "grant"
  
  # If you want to set a password (not recommended for production)
  cipassword = var.common_pass
  
  # SSH Keys
  # sshkeys = <<-EOF
  # "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCvT5eILWKC8aNQxgH6fztcld26znnvu68UK5aS/fip4Eu/dSLjkGYEY6HZsagP56EAZ7SqeNyfJTwfghPyeKYLW72BOrT8XfNf//Ix2sgJzBjKeiXfyJkVDbZs92iiM19q7rhJSk2bOQSSVzyRx3xlixqJIiHMc8Oa+CI3E5rq0ShRIzrXSCYFyiBkxe4GvVVkZ7lLUcA+jn2qboF8EjQsNMV4xsRxWZ15cQXYzYDtH+ol11x1AOfWYPeb7NsOb/kDgCrCRamBj1v5SeHwdF20XWWRVeERbSBNaWR6fvv2vkXDye/IxADZsGgJzwLz8AFkZj8G+z+MmWMaJ8PiHUo7gR9Zws3uLBFxAmAAfFhSN/gozCCsV/Bwnut3rgMQCQudhqeG02dPIhZDMdZ2DERi/zhgfDlJ7aTZpmEmLnkhSAPGj6LlwPgilnmknMP30wCHBkm0uy5K7kkplc4DcNdD153QvG8IMviRgE+aq8KuQMGrTuXIjO2nQzzQHdPy8R8= grant@rocky-x1"
  # EOF
  
  # CPU and Memory
  cpu_type = "host"
  cores = 2
  memory = 2048
  
  # VGA Configuration
  vga {
    type = "std"
  }
  
  # Disk Configuration
  disks {
    scsi {
      scsi0 {
        disk {
          storage = "local"  # Use local-lvm instead of local
          size = 32
        }
      }
    }
  }
  
  # Optional: Ensure cloud-init is properly triggered
  provisioner "local-exec" {
    command = "qm cloudinit dump ${self.vmid} user | echo 'Cloud-init user data dumped'"
  }
}