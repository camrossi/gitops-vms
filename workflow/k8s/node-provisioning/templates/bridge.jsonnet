{
  "apiVersion": "nmstate.io/v1",
  "kind": "NodeNetworkConfigurationPolicy",
  "metadata": {
    "name": $.bond + "-" + $.bridge
  },
  "spec": {
    "nodeSelector": std.parseYaml($.nodeSelector),
    "desiredState": {
      "interfaces": [
        {
          "name": $.bridge,
          "type": "linux-bridge",
          "mtu": 9000,
          "state": "up",
          "ipv4": {
            "enabled": false
          },
          "ipv6": {
            "enabled": false
          },
          "lldp": {
            "enabled": true
          },
          "bridge": {
            "options": {
              "stp": {
                "enabled": false
              }
            },
            "ports": [
              {
                "name": $.bond,
                "vlan": {
                  "mode": "trunk",
                  "trunk-tags": $.trunkTags,
                }
              }
            ]
          }
        }
      ]
    }
  }
}