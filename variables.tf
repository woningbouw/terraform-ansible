variable "vsphere_server" {
  description = "vSphere server"
  type        = string
  sensitive   = true
}

variable "vsphere_datacenter" {
  description = "vSphere data center"
  type        = string
}

variable "vsphere_cluster" {
  description = "vSphere cluster"
  type        = string
}

# variable "vsphere_resource_pool" {
#   description = "vSphere resource pool"
#   type = string
# }
variable "vsphere_datastore" {
  description = "vSphere datastore "
  type        = string
}

variable "vsphere_network" {
  description = "vSphere network name"
  type        = string
}

variable "vsphere_folder_path" {
  description = "path where the vm wil be stored"
  type        = string
}

variable "windows_srv22" {
  description = "windows server 2022 (ie: image_path)"
  type        = string
}

variable "windows_srv19" {
  description = "windows server 2019 (ie: image_path)"
  type        = string
}

variable "ubuntu_svr204"{
  description = "ubuntu 20.4 (ie: image_path)"
  type = string
  default = "Ubuntu-Zabbix-Template"
}
variable "vsphere_count" {
  description = "Aantal virtuele machines"
  default     = 1
  type        = string
}

variable "vm_name" {
  description = "VM Names"
  type        = string
}

variable "vault_adress" {
  description = "vault adress"
  type        = string
}

variable "vault_token" {
  description = "vault token"
  type        = string
  sensitive   = true
}

variable "ipv4_address" {
  description = "VM ipv4 address"
  type = string
}
variable "ipv4_gateway" {
  description = "VM ipv4 gateway"
  type = string
}
variable "computer_name" {
  description = "name of the computer host"
  type = string
}

variable "public_key" {
  description = "public SSH key"
  type = string
  sensitive = true
}
variable "ssh_username" {
  description = "ssh username"
  type = string
}

variable "dns_server_list" {
  type = list(string)
  description = "List of DNS servers"
  default = ["8.8.8.8", "8.8.4.4"]
}