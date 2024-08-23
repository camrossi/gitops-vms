local n = import 'templates/nad.jsonnet';

local vlan = 3712;
local bridge = "br0";

{

  local nad = n {
    vlan:: vlan,
    bridge:: bridge,
  },

  apiVersion: "v1",
  kind: "List",
  items: [nad],
}
