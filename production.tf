resource "proxmox_vm_qemu" "cloud-init" {
    name        = "production-vm"
    vmid        = 1001
    target_node = "pve1"
    clone       = "ubuntu-template"
    full_clone = false
    agent = 1
    scsihw = "virtio-scsi-single"

    os_type = "ubuntu"
    
    cpu{
        sockets = 1
        cores = 1
    }
    memory = 2048

  serial {
    id   = 0
    type = "socket"
  }

  vga {
    type = "serial0"
  }
    disks{
        scsi{
            scsi0{
                disk{
                    size = "32G"
                    storage = "local-lvm"
                }
            }
        }
        ide{
            ide2{
                cloudinit{
                    storage = "local-lvm"
                }
            }
        }
    }
    # Cloud-init configuration
    ciuser      = var.ci_user
    cipassword  = var.ci_password 
    ipconfig0 = "dhcp"
    sshkeys     = file(var.ssh_public_key)
    
    # Optional: Uncomment if you want to set a custom disk size
    # scsihw     = "virtio-scsi-pci"
    
    # Optional: Uncomment if you want to set a custom disk size
    # scsi0      = "${var.storage}:32"
}
