resource "aci_tenant" "map" {
  for_each = {
    for k, v in var.tenants : k => v
  }
  name                          = each.key
}