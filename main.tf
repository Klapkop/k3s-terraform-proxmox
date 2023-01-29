data "github_user" "me" {
  username = var.github_username
}

locals {
    my_keys = join("\n", data.github_user.me.ssh_keys)
}


resource "proxmox_vm_qemu" "proxmox_vm_server" {
  count       = var.k3s_servers.num
  name        = "${var.cluster_name}-server-${count.index}"
  target_node = var.pm_node_name
  clone       = var.pm_template_name
  full_clone  = var.pm_clone_full
  os_type     = "cloud-init"
  agent       = 1
  memory      = var.k3s_servers.memory
  cores       = var.k3s_servers.cores
  scsihw      = "virtio-scsi-pci"
  ciuser      = var.ansible_user
  sshkeys     = local.my_keys
  tags        = "k3s, server, ${var.cluster_name}"
  ipconfig0 = "ip=${var.k3s_servers.ips[count.index]}/${var.network.netmask},gw=${var.network.gateway}"

  network {
      bridge    = var.network.bridge
      model     = "virtio"
      tag       = var.network.tag
  }

  disk {
        type = "scsi"
        storage = var.pm_storage_pool
        size = var.k3s_servers.disk

    }

  lifecycle {
    ignore_changes = [
      ciuser,
      sshkeys,
      disk,
      network
    ]
  }

}

resource "proxmox_vm_qemu" "proxmox_vm_workers" {
  count       = var.k3s_workers.num
  name        = "${var.cluster_name}-worker-${count.index}"
  target_node = var.pm_node_name
  clone       = var.pm_template_name
  full_clone  = var.pm_clone_full
  os_type     = "cloud-init"
  agent       = 1
  memory      = var.k3s_workers.memory
  cores       = var.k3s_workers.cores
  scsihw      = "virtio-scsi-pci"
  ciuser      = var.ansible_user
  sshkeys     = local.my_keys
  tags        = "k3s, worker, ${var.cluster_name}"
  ipconfig0   = "ip=${var.k3s_workers.ips[count.index]}/${var.network.netmask},gw=${var.network.gateway}"

  network {
      bridge    = var.network.bridge
      model     = "virtio"
      tag       = var.network.tag 
  }

  disk {
        type = "scsi"
        storage = var.pm_storage_pool
        size = var.k3s_workers.disk

  }


  lifecycle {
    ignore_changes = [
      ciuser,
      sshkeys,
      disk,
      network
    ]
  }

}

data "template_file" "k8s" {
  template = file("${path.module}/templates/k8s.tpl")
  vars = {
    k3s_server_ip = "${join("\n", [for instance in proxmox_vm_qemu.proxmox_vm_server : join("", [instance.default_ipv4_address, " ansible_ssh_private_key_file=", var.pvt_key])])}"
    k3s_node_ip   = "${join("\n", [for instance in proxmox_vm_qemu.proxmox_vm_workers : join("", [instance.default_ipv4_address, " ansible_ssh_private_key_file=", var.pvt_key])])}"
  }
}

data "template_file" "ansible_vars" {
  template = file("${path.module}/templates/settings.yml.tftpl")
  vars = {
    ansible_user = var.ansible_user
    ansible_tz = var.ansible_tz
    k3s_endpoint_ip = var.network.endpoint
    k3s_token = random_password.k3s_token.result
    k3s_version = var.k3s_version
    kube_vip_version = var.kube_vip_version
    metal_lb_speaker_version = var.metal_lb_speaker_version
    metal_lb_controller_version = var.metal_lb_controller_version
    metal_lb_ip_range = var.network.lb_ip_range
  }
  
}

resource "local_file" "inventory_file" {
  content  = data.template_file.k8s.rendered
  filename = "${var.ansible_inventory_path}/${var.cluster_name}/hosts.ini"
}


resource "local_file" "user_var_file" {
  content  = data.template_file.ansible_vars.rendered
  filename = "${var.ansible_inventory_path}/${var.cluster_name}/group_vars/all.yaml"
}

resource "random_password" "k3s_token" {
  length           = 30
  special          = false
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
