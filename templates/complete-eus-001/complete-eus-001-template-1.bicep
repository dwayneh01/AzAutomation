
param param_location string
param vnetName string
param applicationName string
param subnetName string
@secure()
param vmPass string

param vnetAddressSpace string
var subnets = [for i in range(0,3): cidrSubnet(vnetAddressSpace, 24, i)]

var app1 = '${applicationName}'
var location = '${param_location}'

resource vnet_complete_eus_001 'Microsoft.Network/virtualNetworks@2024-05-01' = {
    name: '${vnetName}'
    location: location
    properties: {
      addressSpace: {
        addressPrefixes: vnetAddressSpace
      }
      subnets: [
        {
          name: 'default'
          properties: {
            addressPrefixes: [subnets[0]]
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
    addressPrefixes: [ subnets[1] ]
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource subnet_containers_vnet_complete_eus_001 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: vnet_complete_eus_001
  name: 'sub-containers'
  properties: {
    addressPrefixes: [ subnets[2] ]
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

