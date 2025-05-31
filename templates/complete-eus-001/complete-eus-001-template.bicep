
var app1 = 'complete-eus-001'
var location = '${paramLocation}'

resource vnet_complete_eus_001 'Microsoft.Network/virtualNetworks@2024-05-01' = {
    name: 'vnet-${app1}'
    location: location
    properties: {
      addressSpace: {
        addressPrefixes: ['124.1.0.0/16']
      }
      subnets: [
        {
          name: 'default'
          properties: {
            addressPrefixes: [ '124.1.0.0/24' ]
            privateEndpointNetworkPolicies: 'Disabled'
            privateLinkServiceNetworkPolicies: 'Enabled'
          }
        }
      ]
    }
}

resource subnet_vm_vnet_complete_eus_001 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: vnet_complete_eus_001
  name: 'sub-vm'
  properties: {
    addressPrefixes: [ '124.1.1.0/24' ]
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource subnet_containers_vnet_complete_eus_001 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: vnet_complete_eus_001
  name: 'sub-containers'
  properties: {
    addressPrefixes: [ '124.1.2.0/24' ]
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    delegations:[
      {
        name: 'sub-containers-dele'
        properties: {serviceName: 'Microsoft.ContainerInstance/containerGroups'}
      }
    ]
  }
}

resource privateDnsZone_complete_eus_001 'Microsoft.Network/privateDnsZones@2024-06-01' = {
    name: 'completeeus.internal'
    location: 'global'
}

