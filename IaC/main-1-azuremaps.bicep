param azuremapname string
param location string = resourceGroup().location

resource azuremaps 'Microsoft.Maps/accounts@2021-12-01-preview' = {
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

var ClientId = listKeys(azuremaps.id, azuremaps.apiVersion).value[0].primaryKey
var ClientId2 = listKeys(azuremaps.id, azuremaps.apiVersion).keys[0].value


output out_AzureMapsAppKey string = azuremaps.id
output out_AzureMapsClientId1 string = ClientId
output out_AzureMapsClientId2 string = ClientId2
