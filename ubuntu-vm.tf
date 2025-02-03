resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  node_name = local.config.nodename

  scsi_hardware = "virtio-scsi-single"

  # should be true if qemu agent is not installed / enabled on the VM
  stop_on_destroy = true

  initialization {
    datastore_id = local.config.vm_disk_id
    ip_config {
      ipv4 {
        address = local.config.address
        gateway = local.config.gateway
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
  }

  cpu {
    sockets = 1
    cores   = 4
  }

  memory {
    dedicated = 4096
  }

  agent {
    enabled = true
  }

  disk {
    datastore_id = local.config.vm_disk_id
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    interface    = "scsi0"
    iothread     = true
    discard      = "on"
    size         = 20
  }

  network_device {
    bridge = "vmbr0"
  }
}

resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  content_type = "iso"
  datastore_id = local.config.data_store_id
  node_name    = local.config.nodename
  url          = local.config.ubuntu_cloud_init_img_url
}

resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  content_type = "snippets"
  datastore_id = local.config.snippet_store_id
  node_name    = local.config.nodename

  source_raw {
    data      = local.ci_userdata
    file_name = "user-data-cloud-config.yml"
  }
}
