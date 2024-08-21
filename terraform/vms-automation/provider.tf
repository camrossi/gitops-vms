terraform {
  required_providers {
    aci = {
      source = "CiscoDevNet/aci"
      version = "2.15.0"
    }
  }
}

provider "aci" {
  username = FAB_USER
  password = FAB_PASS
  url      = FAB_URL
  insecure = true
}