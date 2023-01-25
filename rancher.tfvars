# Proxmox settings
pm_tls_insecure = true
pm_host = "10.1.0.5"
pm_clone_full = true
pm_storage_pool = "local-lvm"
pm_node_name = "pve"
pm_template_name = "ubuntu-2204-cloudinit-template"
pm_network_bridge = "vmbr1"

# Ansible
github_username = "klapkop"
ansible_user = "ansible"
ansible_inventory_path = "../k3s-ansible/inventory"
ansible_tz = "Europe/Amsterdam"

# k3s
cluster_name = "rancher"
k3s_version = "v1.24.9+k3s1"
kube_vip_version = "v0.5.7"
metal_lb_speaker_version = "v0.13.7"
metal_lb_controller_version = "v0.13.7"


k3s_servers = {
  num = 3
  cores = 2
  memory = 2048
  disk = "50G"
  ips = [
    "10.102.0.20",
    "10.102.0.21",
    "10.102.0.22"
    ]
}

k3s_workers = {
  num = 3
  cores = 4
  memory = 4048
  disk = "50G"
  ips = [
    "10.102.0.30",
    "10.102.0.31",
    "10.102.0.32"
    ]
}

network = {
  tag = 102
  bridge = "vmbr1"
  endpoint = "10.102.0.10"
  lb_ip_range = "10.102.0.100-10.102.0.110"
  gateway = "10.102.0.1"
  netmask = 24
}
  


