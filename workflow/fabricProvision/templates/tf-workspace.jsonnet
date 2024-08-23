{
    apiVersion: 'app.terraform.io/v1alpha2',
    kind: 'Workspace',
    metadata: {
      name: 'vlan' + $.vlan.id,
      "annotations": {
        "workspace.app.terraform.io/run-type": "apply",
        "workspace.app.terraform.io/run-new": "true"
      },
    },
    spec: {
      organization: 'camrossi',
      project: {
        name: $.project,
      },
      token: {
        secretKeyRef: {
          name: 'tfc-owner',
          key: 'token',
        },
      },
      name: 'vlan' + $.vlan.id,
      description: 'Kubernetes Operator Automated Workspace',
      applyMethod: 'auto',
      terraformVersion: '1.9.5',
      terraformVariables: [
        {
          name: 'tenant',
          value: std.toString($.tenant),
        },
        {
          name: 'app',
          value: std.toString($.app),
        },
        {
          name: 'vlan_config',
          hcl: true,
          value: std.toString($.vlan),
        },
        {
          name: 'phys_domain',
          value: std.toString($.phys_domain),
        },
        {
          name: 'ports',
          hcl: true,
          value: std.toString($.ports) ,
        },
        {
          name: 'apic_url',
          sensitive: true,
          value: std.toString($.apic_url),
        },
        {
          name: 'apic_user',
          value: std.toString($.apic_user),
        },
        {
          name: 'apic_pass',
          sensitive: true,
          valueFrom: {
            secretKeyRef: {
              name: std.toString($.apic_pass_secret),
              key: 'apic_pass',
            },
          },
        },
      ],
      tags: ['k8s'],
      executionMode: 'agent',
      agentPool: {
        name: std.toString($.agentPool),
      },
    },
  }