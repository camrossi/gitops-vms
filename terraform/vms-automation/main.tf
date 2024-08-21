resource "aci_tenant" "map" {
  for_each = var.tenants
  name                          = each.key
}