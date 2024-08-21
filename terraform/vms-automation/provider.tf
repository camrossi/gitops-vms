terraform {
  required_providers {
    aci = {
      source = "CiscoDevNet/aci"
      version = "2.15.0"
    }
  }
}

provider "aci" {
  username = apic_user
  password = apic_pass
  url      = apic
  insecure = true
}