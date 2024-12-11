resource "proxmox_vm_qemu" "k8s-lb-test" {
  name = "k8s-lb-test"
  target_node = var.target_node

  clone = var.clone_template

  # agent = 1
  full_clone = true
  os_type = "cloudinit"
  cores = 2
  sockets = 1
  cpu_type = "host"
  memory = 2048
  boot = "order=ide0;scsi0;net0"
  scsihw = "virtio-scsi-single"
  
  network {
    id = 0
    model = "virtio"
    bridge = "SrvVlan"
  }

  disk {
    slot = "scsi0"
    size = "32G"
    emulatessd = true
    discard = true
    iothread = true
    storage = "local"
  }

  vga {
    type = "std"
    memory = 4
  }

  ipconfig0 = "ip=${var.vm_static_ip}/24,gw=192.168.5.1"

  disk {
    type = "cloudinit"
    slot = "ide0"
    storage = "local"
  }

  # Cloud init
  ciuser = var.ciuser
  cipassword = var.cipassword
  ciupgrade = true
    
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}