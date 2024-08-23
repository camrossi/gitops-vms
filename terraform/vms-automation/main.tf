data "aci_tenant" "tenant" {
  name  = var.tenant
}

resource "aci_application_profile" "app" {
  for_each = var.vlans
  tenant_dn  = data.aci_tenant.tenant.id
  name       = var.each.App
}

data "aci_application_epg" "vlan" {
  for_each = var.vlans
  application_profile_dn  = aci_application_profile.app.id
  name = var.vlan
}

resource "aci_epg_to_domain" "phys_domain" {
  depends_on         = [data.aci_application_epg.vlan]
  application_epg_dn    = data.aci_application_epg.vlan.id
  tdn                   = var.phys_domain
}

#resource "aci_bridge_domain" "bd" {
#  for_each = var.vlans
#
#  tenant_dn          = aci_tenant.demo.id
#  name               = each.value.name
#  arp_flood          = each.value.arp_flood
#  unicast_route      = each.value.type == "L3" ? "yes" : "no"
#  unk_mac_ucast_act  = each.value.type == "L3" ? "proxy" : "flood"
#  unk_mcast_act      = "flood"
#  relation_fv_rs_ctx = aci_vrf.main.id
#}
#
#resource "aci_bulk_epg_to_static_path" "static_paths" {
#  depends_on         = [data.aci_application_epg.vlan]
#  application_epg_dn = data.aci_application_epg.vlan.id
#  dynamic "static_path" {
#    for_each = var.ports
#    content {
#      encap = "vlan-${var.vlan}"
#      interface_dn = static_path.value
#      mode         = "regular"
#      
#    }
#  }
#}