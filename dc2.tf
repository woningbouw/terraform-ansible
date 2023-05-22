resource "vsphere_virtual_machine" "dc2" {
  name = "woningbouw-dc2"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id 
  datastore_id = data.vsphere_datastore.datastore.id
  folder = var.vsphere_folder_path
  num_cpus = 2
  memory = 1024
  firmware = data.vsphere_virtual_machine.windowsserver22.firmware
  guest_id = data.vsphere_virtual_machine.windowsserver22.guest_id
  

  # The network interface the vm get connected to
  network_interface {
    network_id = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.windowsserver22.network_interface_types[0]
    
  }

  wait_for_guest_net_timeout = 1
  wait_for_guest_ip_timeout = 1
  # atributes for customizing the disk of the vm.
  # they get the same atributes as the machine they get cloned from
  disk {
    label = "disk0"
    thin_provisioned = data.vsphere_virtual_machine.windowsserver22.disks.0.thin_provisioned
    size = data.vsphere_virtual_machine.windowsserver22.disks.0.size
  }
    // Windows Template
  clone {
    template_uuid = data.vsphere_virtual_machine.windowsserver22.id
    customize {
      windows_options {
        computer_name = "woningbouw-dc2"
        join_domain = "Woningbouw.local"
        domain_admin_user = "Administrator"
        domain_admin_password = data.vault_generic_secret.netlablogin.data["winadminpassword"]
        
      }
      network_interface {
        ipv4_address    = "192.168.9.3"
        ipv4_netmask    = 24
        dns_server_list = ["192.168.9.2", "208.91.112.52", "208.91.112.53"]
      }
      ipv4_gateway = var.ipv4_gateway
    }

  }
  provisioner "remote-exec" {
    inline = [
      "cmd.exe /c net user administrator /passwordreq:yes", 
      "cmd.exe /c wmic useraccount where name='administrator' Set PasswordExpires=false"
      ]
      connection {
        type = "winrm"
        user = "ansible"
        password = data.vault_generic_secret.netlablogin.data["winrmansible"]
        host = "192.168.9.3"
      }
    
  }
   provisioner "local-exec" {
    working_dir = "ansible"
    command = "sleep 120; ansible-playbook domain-backup.yml"
  }
}