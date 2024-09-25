local ap = std.parseYaml(importstr '../../ansible/access_vars.yaml');
local nadt = import 'templates/nad.jsonnet';
local vmt = import 'templates/vm.jsonnet';
local sshKey = "AAAAB3NzaC1yc2EAAAADAQABAAABAQC+7s7Pc1s+8BpEGpygHuRzssjiHMyFwbhZRKK0PyEqWy9mm8kYExYAhmg+cNgntWovpRQ6w+6+bUXhThnyZiWsXzciNJ2/8iwmfVr79klnDkR1y/gv7S1e3DZP+YATy65RPcRu4LUWuQIb58S18NMG5EA84NUEl4TcwRCoAHX3Z3hkUvTZMZUpgPod+TEp+jgHiKKwLKR7+k/ehDa2x0l7acT0O2v2iBqCv8sar2J/9JkqQjmFf7THkwadVtUvyQJG2CFH6NlYbD4dNkNjfJucUyJhB0tDXQAtAOQH+LQM0hNWBsmfvolQQVz0UBL0Axe9eaTUuGP2fe7pYQyTWbKT cisco@bm-01";

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
  networkName:: "vlan" + vlan,
  sshKey:: sshKey
}];

local vm2(vlan) = [vmt {
  name:: "vm2-vlan" + vlan,
  vlan:: vlan,
  networkName:: "vlan" + vlan,
  sshKey:: sshKey
}];

{
  apiVersion: 'v1',
  kind: 'List',
  items: std.flattenArrays(
    [
      nads(epg.vlan, std.extVar('bridge'))
      for aaep in ap.aaeps
          for epg in aaep.aci_aep_to_epg
            if epg.application_profile == std.extVar('namespace')
    ] + 
      [
      vm(epg.vlan)
      for aaep in ap.aaeps
          for epg in aaep.aci_aep_to_epg
            if epg.application_profile == std.extVar('namespace')
      ]
    + 
      [
      vm2(epg.vlan)
      for aaep in ap.aaeps
          for epg in aaep.aci_aep_to_epg
            if epg.application_profile == std.extVar('namespace')
      ]
  ) 
}
