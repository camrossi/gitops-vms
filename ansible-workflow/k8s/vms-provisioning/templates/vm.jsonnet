{
  "apiVersion": "kubevirt.io/v1",
  "kind": "VirtualMachine",
  "metadata": {
    "name": $.name,
    "labels": {
      "name": $.name
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
            "name": "default",
            "masquerade": {}
          },
          {
            "name": std.toString($.vlan),
            "bridge": {}
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
        "name": std.toString($.vlan),
        "multus": {
          "networkName": $.networkName
        }
      }
    ],
    "volumes": [
      {
        "name": "containerdisk",
        "containerDisk": {
          "image": "quay.io/camillo/alpine:cloudinit"
        }
      },
      {
        "name": "cloudinitdisk",
        "cloudInitNoCloud": {
          "userData": "ssh_authorized_keys:\n  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+7s7Pc1s+8BpEGpygHuRzssjiHMyFwbhZRKK0PyEqWy9mm8kYExYAhmg+cNgntWovpRQ6w+6+bUXhThnyZiWsXzciNJ2/8iwmfVr79klnDkR1y/gv7S1e3DZP+YATy65RPcRu4LUWuQIb58S18NMG5EA84NUEl4TcwRCoAHX3Z3hkUvTZMZUpgPod+TEp+jgHiKKwLKR7+k/ehDa2x0l7acT0O2v2iBqCv8sar2J/9JkqQjmFf7THkwadVtUvyQJG2CFH6NlYbD4dNkNjfJucUyJhB0tDXQAtAOQH+LQM0hNWBsmfvolQQVz0UBL0Axe9eaTUuGP2fe7pYQyTWbKT cisco@bm-01\n"
        }
      }
    ]
  }
}