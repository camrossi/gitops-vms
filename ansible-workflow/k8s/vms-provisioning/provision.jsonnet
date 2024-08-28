local ap = std.parseYaml(importstr '../../ansible/access_vars.yaml');
local nadt = import 'templates/nad.jsonnet';
local vmt = import 'templates/vm.jsonnet';


// I decided the ACI application names maps to a namespace in K8s
// The tenant is ignored, 1 K8s Cluster == 1 Tennat for now, this is just an example
// Argo CD passes to jsonnet the Namespace name so we can simply deploy this across X namespaces
// and only the rifght NAD are deployed

local nads(vlan, bridge) = [nadt {
  vlan:: vlan,
  bridge:: bridge,
}];

local vm(vlan) = [vmt {
  name:: "vm1-vlan" + vlan,
  vlan:: vlan,
  networkName:: "vlan" + vlan
}];


{
  apiVersion: 'v1',
  kind: 'List',
  items: std.flattenArrays(
    [
      nads(epg.vlan, std.extVar('bridge'))
      for aaep in ap.aaeps
          for epg in aaep.aci_aep_to_epg
            if epg.app_name == std.extVar('namespace')
    ] + 
      [
      vm(epg.vlan)
      for aaep in ap.access_policies.aaeps
          for epg in aaep.endpoint_groups
            if epg.application_profile == std.extVar('namespace')
      ]
  ) 
}
