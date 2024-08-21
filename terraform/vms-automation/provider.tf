terraform {
  required_providers {
    aci = {
      source = "CiscoDevNet/aci"
      version = "2.15.0"
    }
  }
}

provider "aci" {
  username = var.apic_user
  password = var.apic_pass
  url      = var.apic
  insecure = true
}