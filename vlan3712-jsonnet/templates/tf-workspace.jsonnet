{
    apiVersion: 'app.terraform.io/v1alpha2',
    kind: 'Workspace',
    metadata: {
      name: 'vlan' + $.vlan,
      "annotations": {
        "workspace.app.terraform.io/run-type": "apply"
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
      name: 'vlan' + $.vlan,
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
          name: 'vlan',
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
      executionMode: 'agent',
      agentPool: {
        name: std.toString($.agentPool),
      },
    },
  }