# creates ssh-keypair for ansible
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
#stores ssh-privateket localy in the .shh map
resource "local_sensitive_file" "pem_file" {
  filename= pathexpand("~/.ssh/ansible")
  file_permission = "600"
  directory_permission = "700"
  content              = tls_private_key.pk.private_key_openssh
}



# variables for the template
locals {
  shhbeforetrim = trimspace(tls_private_key.pk.public_key_openssh)
  sstrimmed     = trim(local.shhbeforetrim, "ssh-rsa ")
  templatevars = {
    name         = "zabbix-server"  ,
    ipv4_address = "192.168.9.5",
    ipv4_gateway = "192.168.9.1",
    dns_server_1 = var.dns_server_list[0],
    dns_server_2 = var.dns_server_list[1],
    public_key = var.public_key,
    ssh_username = var.ssh_username
  }
}




# creates the Vm rescourse speciefied parameters of the vm
resource "vsphere_virtual_machine" "zabbix" {
  name = " woningbouw-monitoring"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id 
  datastore_id = data.vsphere_datastore.datastore.id
  folder = var.vsphere_folder_path
  num_cpus                = 2
  memory                   = 2096
  firmware = data.vsphere_virtual_machine.ubuntu204.firmware
  guest_id = data.vsphere_virtual_machine.ubuntu204.guest_id
  depends_on = [vsphere_virtual_machine.fs1]

  # The network interface the vm get connected to
  network_interface {
    network_id = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.ubuntu204.network_interface_types[0]
  }

  wait_for_guest_net_timeout = 1
  wait_for_guest_ip_timeout = 1
  # atributes for customizing the disk of the vm.
  # they get the same atributes as the machine they get cloned from
  disk {
    label = "disk0"
    thin_provisioned = data.vsphere_virtual_machine.ubuntu204.disks.0.thin_provisioned
    size = data.vsphere_virtual_machine.ubuntu204.disks.0.size
  }
    // ubuntu 20.4 template
  clone {
    template_uuid = data.vsphere_virtual_machine.ubuntu204.id
  }
  extra_config = {
    "guestinfo.metadata"          = base64encode(templatefile("${path.module}/templates/metadata.yaml", local.templatevars))
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode(templatefile("${path.module}/templates/userdata.yaml", local.templatevars))
    "guestinfo.userdata.encoding" = "base64"
  }
  lifecycle {
    ignore_changes = [
      annotation,
      clone[0].template_uuid,
      clone[0].customize[0].dns_server_list,
      clone[0].customize[0].network_interface[0]
    ]
  }
  provisioner "local-exec" {
    working_dir = "ansible"
    command     = "sleep 120; ansible-playbook zabbix-setup.yml --extra-vars  zabbixpasswordsql=${data.vault_generic_secret.netlablogin.data["zabbixsql"]},rootpassword=${data.vault_generic_secret.netlablogin.data["rootsql"]}"
  }

}