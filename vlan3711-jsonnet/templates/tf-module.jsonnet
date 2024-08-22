{
    apiVersion: 'app.terraform.io/v1alpha2',
    kind: 'Module',
    metadata: {
      name: 'aci-module-vlan' + $.vlan,
    },
    spec: {
      organization: 'camrossi',
      token: {
        secretKeyRef: {
          name: 'tfc-owner',
          key: 'token',
        },
      },
      destroyOnDeletion: true,
      module: {
        source: 'github.com/camrossi/gitops-vms/terraform/vms-automation',
      },
      variables: [
        {
          name: 'tenant',
        },
        {
          name: 'app',
        },
        {
          name: 'vlan',
        },
        {
          name: 'phys_domain',
        },
        {
          name: 'ports',
        },
        {
          name: 'apic_url',
        },
        {
          name: 'apic_user',
        },
        {
          name: 'apic_pass',
        },
      ],
      workspace: {
        name: 'vlan' +  $.vlan,
      },
    },
  }