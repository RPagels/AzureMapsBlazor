param azuremapname string
param location string = resourceGroup().location

resource accounts_azuremaps_name_resource 'Microsoft.Maps/accounts@2021-12-01-preview' = {
  name: azuremapname
  location: location
  sku: {
    name: 'G2'
    //tier: 'Standard'
  }
  kind: 'Gen2'
  identity: {
    type: 'None'
  }
  properties: {
    disableLocalAuth: false
    cors: {
      corsRules: [
        {
          allowedOrigins: []
        }
      ]
    }
  }
}
