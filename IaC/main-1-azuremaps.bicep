param accounts_azuremaps_name string = 'azuremaps'

resource accounts_azuremaps_name_resource 'Microsoft.Maps/accounts@2021-12-01-preview' = {
  name: accounts_azuremaps_name
  location: 'eastus'
  sku: {
    name: 'G2'
    tier: 'Standard'
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
