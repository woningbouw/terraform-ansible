terraform {
  cloud {
    organization = "fontys-woningbouw"

    workspaces {
      name = "vsphere"
    }
  }

  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.0.2"
    }
  }
}

provider "vsphere" {
  user                 = data.vault_generic_secret.netlablogin.data["vsphereuser"]
  password             = data.vault_generic_secret.netlablogin.data["vspherepassword"]
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

provider "vault" {
  address = var.vault_adress
  token = var.vault_token
}