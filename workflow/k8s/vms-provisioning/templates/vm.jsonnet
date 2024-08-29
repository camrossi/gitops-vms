{
  "apiVersion": "kubevirt.io/v1",
  "kind": "VirtualMachine",
  "metadata": {
    "labels": {
      "app": $.name,
      "kubevirt.io/dynamic-credentials-support": "true",
      "vm.kubevirt.io/template": "rhel9-server-small",
      "vm.kubevirt.io/template.namespace": "openshift",
      "vm.kubevirt.io/template.revision": "1",
      "vm.kubevirt.io/template.version": "v0.29.1"
    },
    "name": $.name,
    "namespace": std.extVar('namespace')
  },
  "spec": {
    "dataVolumeTemplates": [
      {
        "apiVersion": "cdi.kubevirt.io/v1beta1",
        "kind": "DataVolume",
        "metadata": {
          "creationTimestamp": null,
          "name": $.name
        },
        "spec": {
          "sourceRef": {
            "kind": "DataSource",
            "name": "rhel9",
            "namespace": "openshift-virtualization-os-images"
          },
          "storage": {
            "resources": {
              "requests": {
                "storage": "30Gi"
              }
            }
          }
        }
      }
    ],
    "running": true,
    "template": {
      "metadata": {
        "annotations": {
          "vm.kubevirt.io/flavor": "small",
          "vm.kubevirt.io/os": "rhel9",
          "vm.kubevirt.io/workload": "server"
        },
        "creationTimestamp": null,
        "labels": {
          "kubevirt.io/domain": $.name,
          "kubevirt.io/size": "small"
        }
      },
      "spec": {
        "architecture": "amd64",
        "domain": {
          "cpu": {
            "cores": 1,
            "sockets": 1,
            "threads": 1
          },
          "devices": {
            "disks": [
              {
                "disk": {
                  "bus": "virtio"
                },
                "name": "rootdisk"
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
                "model": "virtio",
                "name": std.toString($.vlan)
              }
            ],
            "rng": {}
          },
          "features": {
            "acpi": {},
            "smm": {
              "enabled": true
            }
          },
          "firmware": {
            "bootloader": {
              "efi": {}
            }
          },
          "machine": {
            "type": "pc-q35-rhel9.4.0"
          },
          "memory": {
            "guest": "2Gi"
          },
          "resources": {}
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
            "name": std.toString($.vlan)
          }
        ],
        "terminationGracePeriodSeconds": 180,
        "volumes": [
          {
            "dataVolume": {
              "name": $.name
            },
            "name": "rootdisk"
          },
          {
            "cloudInitNoCloud": {
              "userData": "user: cloud-user\npassword: 123Cisco123\nchpasswd: { expire: False }\nssh_authorized_keys:\n  - ssh-rsa " + $.sshKey
            },
            "name": "cloudinitdisk"
          }
        ]
      }
    }
  }
}