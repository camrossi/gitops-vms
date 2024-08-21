data "aci_tenant" "tenant" {
  name  = var.tenant
}

data "aci_application_profile" "app" {
  tenant_dn  = aci_tenant.tenant.id
  name       = var.app
}

data "aci_application_epg" "vlans" {
  for_each = toset(var.vlans)
  application_profile_dn  = aci_application_profile.app.id
  name = each.key
}

resource "aci_epg_to_domain" "phys_domain" {
  depends_on         = [aci_application_epg.vlans]
  for_each           = aci_application_epg.vlans
  application_epg_dn    = aci_application_epg.each.vlans.id
  tdn                   = aci_fc_domain.foofc_domain.id
}

resource "aci_bulk_epg_to_static_path" "static_paths" {
  depends_on         = [aci_application_epg.vlans]
  for_each           = aci_application_epg.vlans
  application_epg_dn = aci_application_epg.vlans[each.key].id
  dynamic "static_path" {
    for_each = var.ports
    content {
      encap = each.key
      interface_dn = static_path.each.key
      mode         = "trunk"
      
    }
  }
}