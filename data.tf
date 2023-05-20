# Collects data from the datacenter
data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

# Collects data from the Datastore cluster
data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Collects data from the vsphere cluster
data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

# # Collects data from te resource pool
# data "vsphere_resource_pool" "pool" {
#   name          = var.vsphere_resource_pool
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

# Collects data from the vsphere network
data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

/* Windows 10 Template
data "vsphere_virtual_machine" "windows_10" {
  name          = var.vsphere_windows_10
  datacenter_id = data.vsphere_datacenter.dc.id
} */

# Collects the windows server22 VM template in Vsphere
data "vsphere_virtual_machine" "windowsserver22" {
  name          = var.windows_srv22
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Collects the windows server19 VM template in Vsphere
data "vsphere_virtual_machine" "windowsserver19" {
  name          = var.windows_srv19
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "ubuntu204" {
  name          = var.ubuntu_svr204
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vault_generic_secret" "netlablogin" {
  path = "kv-woningbouw/vsphere-ralf"
}