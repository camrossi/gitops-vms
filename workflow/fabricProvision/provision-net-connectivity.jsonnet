local n = import 'templates/nad.jsonnet';
local tfM = import 'templates/tf-module-nac.jsonnet';
local tfW = import 'templates/tf-workspace.jsonnet';

local vlans = import '../vlans.json';

local bridge = "br0";
local project = 'fab2';
local apic_url = 'https://192.168.68.34';
local apic_user = 'terraform' ;
local apic_pass_secret = 'apicpass' ;
local tenant = "tf-vms-1";
local app = "vms";
local phys_domain = 'uni/phys-ocp_sr_iov-secondary';
local ports = [
  "topology/pod-1/protpaths-201-202/pathep-[ocpbm-bm-03-bond1]", 
  "topology/pod-1/protpaths-201-202/pathep-[bm-02-bond1]"
];
local agentPool = 'agent-pool-ocp-baremetal' ;

local tfModule(v) = [tfM {
  vlan:: v,
}];

local tfWorkspace(v) = [tfW {
    project:: project,
    tenant:: tenant,
    app:: app,
    vlan:: v,
    phys_domain:: phys_domain,
    ports:: ports,
    apic_url:: apic_url,
    apic_user:: apic_user,
    apic_pass_secret:: apic_pass_secret,
    agentPool:: agentPool,
  }];

{
  
  apiVersion: "v1",
  kind: "List",
  items: std.flattenArrays(
    [tfWorkspace(v)for v in vlans] + 
    [tfModule(v)for v in vlans]
    )
}



