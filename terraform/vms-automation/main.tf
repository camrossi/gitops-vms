resource "aci_tenant" "map" {
  for_each = toset(var.tenants)
  name                          = each.key
}