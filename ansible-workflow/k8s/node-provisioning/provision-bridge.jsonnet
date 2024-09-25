local ap = std.parseYaml(importstr '../../ansible/access_vars.yaml');
local n = import 'templates/bridge.jsonnet';


// I decided the ACI application names maps to a namespace in K8s
// The tenant is ignored, 1 K8s Cluster == 1 Tennat for now, this is just an example
// Argo CD passes to jsonnet the Namespace name so we can simply deploy this across X namespaces
// and only the rifght NAD are deployed

local bridge(bond, bridge, nodeSelector, trunkTags) = [n {
  bond:: bond,
  bridge:: bridge,
  nodeSelector:: nodeSelector,
  trunkTags:: trunkTags,
}];

local trunkTags =
  [ 
    if range.from == range.to then { id: range.from }
    else {
      'id-range':
        {
          min: range.from,
          max: range.to,
        }
    }
    for vlan_pool in ap.vlan_pools
    for range in vlan_pool.ranges
  ] 
  # ACI Infra VLAN
  +  [{id: 3456}];


bridge(std.extVar('bond'), std.extVar('bridge'), std.extVar('nodeSelector'), trunkTags)