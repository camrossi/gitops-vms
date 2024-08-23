local ap = std.parseYaml(importstr '../nac/data/aaep.nac.yaml').apic;
local n = import 'templates/nad.jsonnet';
//local ns = "vms-1";


// I decided the ACI application names maps to a namespace in K8s
// The tenant is ignored, 1 K8s Cluster == 1 Tennat for now, this is just an example
// Argo CD passes to jsonnet the Namespace name so we can simply deploy this across X namespaces
// and only the rifght NAD are deployed

local nads(vlan, bridge) = [n {
  vlan:: vlan,
  bridge:: bridge,
}];

{
  apiVersion: 'v1',
  kind: 'List',
  items: std.flattenArrays(
    [
      nads(epg.primary_vlan, aaep.description)
      for aaep in ap.access_policies.aaeps
          for epg in aaep.endpoint_groups
            if epg.application_profile == std.extVar('namespace')
    ]
  ),
}
