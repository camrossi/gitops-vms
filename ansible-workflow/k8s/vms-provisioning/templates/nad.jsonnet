{
  "apiVersion": "k8s.cni.cncf.io/v1",
  "kind": "NetworkAttachmentDefinition",
  "metadata": {
    "name": "vlan" + $.vlan,
    #"annotations": {
    #  "k8s.v1.cni.cncf.io/resourceName": "bridge.network.kubevirt.io/" + $.bridge
    #}
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