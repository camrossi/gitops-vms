{
    "apiVersion": "v1",
    "kind": "Service",
    "metadata": {
        "name": $.name + "-ssh",
    },
    "spec": {

        "externalTrafficPolicy": "Cluster",
        "internalTrafficPolicy": "Cluster",
        "ipFamilies": [
            "IPv4"
        ],
        "ipFamilyPolicy": "SingleStack",
        "ports": [
            {
                "port": 22,
                "protocol": "TCP",
                "targetPort": 22
            }
        ],
        "selector": {
            "kubevirt.io/domain": $.name
        },
        "sessionAffinity": "None",
        "type": "NodePort"
    }
}