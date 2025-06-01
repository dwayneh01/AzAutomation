
param param_location string
param vnetName string
param applicationName string
param subnetName string

var app1 = '${applicationName}'



resource publicip_vm_complete_eus_001 'Microsoft.Network/publicIPAddresses@2024-05-01' = {
  name: 'publicip-vm-${app1}-${base64('fghfhfhfg')}'
  location: resourceGroup().location
  sku:{
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

resource nic_vm_complete_eus_001 'Microsoft.Network/networkInterfaces@2024-05-01' = {

  name: 'nic-vm-${app1}' 
  location: resourceGroup().location
  properties: {
    networkSecurityGroup: { id: nsg_complete_eus_001.id } 
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resourceId(resourceGroup().name,'Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
          }
          publicIPAddress: {
            id: publicip_vm_complete_eus_001.id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }

}

resource nsg_complete_eus_001 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: 'nsg-${app1}'
  location: resourceGroup().location
  properties: {
    securityRules: [
      { 
        name:'Allow-SSH'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange:'*'
          destinationPortRange: '22'
          sourceAddressPrefix:'*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }

}



resource vm_complete_eus_001 'Microsoft.Compute/virtualMachines@2024-11-01' = {
    name: 'vm-${app1}'
    location: resourceGroup().location

    properties: {
      hardwareProfile: {
        vmSize: 'Standard_B1s'
      }
      storageProfile: {
        imageReference: {
          publisher: 'Canonical'
          offer:'ubuntu-24_10'
          sku:'server'
          version:'Latest'
        }

        osDisk: {
          
          createOption:'FromImage'      
        }
      }
      osProfile: {
        computerName: 'vm-${app1}'
        adminUsername: 'dherbert'
        adminPassword: 'Ghrfdeilkhgfbdrishgrfdgber!'
      }
      networkProfile: {
        networkInterfaces: [
          {
              id: nic_vm_complete_eus_001.id
          }
        ]
      }

    }
}
