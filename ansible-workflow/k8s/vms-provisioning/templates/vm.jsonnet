{
  "apiVersion": "kubevirt.io/v1",
  "kind": "VirtualMachine",
  "metadata": {
    "labels": {
      "name": $.name
    },
    "name": $.name
  },
  "spec": {
    "running": true,
    "template": {
      "metadata": {
        "labels": {
          "kubevirt.io/vm": $.name
        }
      },
      "spec": {
        "domain": {
          "devices": {
            "disks": [
              {
                "disk": {
                  "bus": "virtio"
                },
                "name": "containerdisk"
              },
              {
                "disk": {
                  "bus": "virtio"
                },
                "name": "cloudinitdisk"
              }
            ],
            "interfaces": [
              {
                "masquerade": {},
                "name": "default"
              },
              {
                "bridge": {},
                "name": std.toString($.vlan),
              }
            ]
          },
          "resources": {
            "requests": {
              "memory": "256M"
            }
          }
        },
        "networks": [
          {
            "name": "default",
            "pod": {}
          },
          {
            "multus": {
              "networkName": $.networkName
            },
            "name": std.toString($.vlan),
          }
        ],
        "volumes": [
          {
            "containerDisk": {
              "image": "quay.io/camillo/alpine:cloudinit"
            },
            "name": "containerdisk"
          },
          {
            "cloudInitNoCloud": {
              "userData": "#cloud-config\nssh_authorized_keys:\n  - ssh-rsa " + $.sshKey
            },
            "name": "cloudinitdisk"
          }
        ]
      }
    }
  }
}