{
  "apiVersion": "k8s.cni.cncf.io/v1",
  "kind": "NetworkAttachmentDefinition",
  "metadata": {
    "name": "vlan" + $.vlan,
  },
  spec: {
      config: std.manifestJson(
        {
          cniVersion: '0.3.1',
          name: "vlan" + $.vlan,
          plugins: [
            {
              bridge: $.bridge,
              type: 'bridge',
              vlan: $.vlan,
            },
          ],
        }
      ),
    },
}