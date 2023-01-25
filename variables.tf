variable "pm_tls_insecure" {
  description = "Set to true to ignore certificate errors"
  type        = bool
  default     = false
}

variable "pm_host" {
  description = "The hostname or IP of the proxmox server"
  type        = string
}

variable "pm_node_name" {
  description = "name of the proxmox node to create the VMs on"
  type        = string
  default     = "pve"
}

variable "pm_template_name" {
  type = string
  description = "Name of Proxmox template to use for nodes"
}

variable "pm_clone_full" {
  description = "Perform full clone of template"
  type = bool
  default = false
}

variable "pm_storage_pool" {
  description = "Proxmox storage pool to use"
  type = string
  default = "local-lvm"
  
}
variable "pm_network_bridge" {
  type = string
  default = "vmbr0"
}

variable "pvt_key" {
  default = "~/.ssh/id_rsa"
}

variable "github_username" {
  description = "Github username for importing public ssh keys"
  type = string
}

variable "cluster_name" {
  description = "Name of k3s cluster used for naming resources"
  type = string
}

variable "ansible_user" {
  description = "Ansible user to be set by cloud-init and user by Ansible"
  type = string
  default = "ansible"
  
}

variable "ansible_inventory_path" {
  description = "Path to Ansible inventory dir"
  type = string
}

variable "ansible_tz" {
  description = "Timezone set by Ansible"  
}

variable "k3s_version" {
  type = string
  description = "k3s version to install"
}


variable "kube_vip_version" {
  type = string
  description = "Kubevip version to install on cluster"
}

variable "metal_lb_speaker_version" {
  type = string
  description = "Metallb version to install on cluster"
}

variable "metal_lb_controller_version" {
  type = string
  description = "Kubevip version to install on cluster"
}

variable "k3s_servers" {
  type = object({
    num = number
    cores = number
    memory = number
    disk = string
    ips = list(string)
  })
}

variable "k3s_workers" {
  type = object({
    num = number
    cores = number
    memory = number
    disk = string
    ips = list(string)
  })
}

variable "network" {
  type = object({
    tag = number
    bridge = string
    endpoint = string
    lb_ip_range = string
    netmask = number
    gateway = string
  })
  
}






