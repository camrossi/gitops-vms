local tenant = std.parseYaml(importstr '../nac/data/tenant_VMs.nac.yaml').apic.tenants;
local n = import 'templates/nad.jsonnet';
local ns = "vms-1";


# I decided the ACI application names maps to a namespace in K8s
# The tenant is ignored, 1 K8s Cluster == 1 Tennat for now, this is just an example
# Argo CD passes to jsonnet the Namespace name so we can simply deploy this across X namespaces
# and only the rifght NAD are deployed
    
local nads(vlan, bridge) = [n {
    vlan:: vlan,
    bridge:: bridge,
}];


{
  apiVersion: "v1",
  kind: "List",
  items: std.flattenArrays(
    [
      nads(e.static_ports[0].vlan, e.description) for t in tenant
        for a in t.application_profiles
            if a.name == std.extVar('namespace')
            for e in a.endpoint_groups
                if (std.objectHas(e, 'static_ports'))
        
    ]

    )
}