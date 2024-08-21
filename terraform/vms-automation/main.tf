resource "aci_tenant" "map" {
  for_each = {
    for k, v in tenants : k => v
  }
  description                   = each.value.description
  name                          = each.key
  name_alias                    = each.value.alias
}