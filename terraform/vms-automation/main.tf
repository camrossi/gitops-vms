data "aci_tenant" "tenant" {
  name  = var.tenant
}

data "aci_application_profile" "app" {
  tenant_dn  = data.aci_tenant.tenant.id
  name       = var.app
}

data "aci_application_epg" "vlan" {
  application_profile_dn  = data.aci_application_profile.app.id
  name = var.vlan
}

resource "aci_epg_to_domain" "phys_domain" {
  depends_on         = [data.aci_application_epg.vlan]
  application_epg_dn    = data.aci_application_epg.vlan.id
  tdn                   = var.phys_domain
}

resource "aci_bulk_epg_to_static_path" "static_paths" {
  depends_on         = [data.aci_application_epg.vlan]
  application_epg_dn = data.aci_application_epg.vlan.id
  dynamic "static_path" {
    for_each = var.ports
    content {
      encap = "vlan-${each.key}"
      interface_dn = static_path.value
      mode         = "regular"
      
    }
  }
}