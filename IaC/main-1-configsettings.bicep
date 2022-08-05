param keyvaultName string
param webappName string
//param functionAppName string
// param secret_AzureWebJobsStorageName string
// param secret_WebsiteContentAzureFileConnectionStringName string
param appInsightsInstrumentationKey string
param appInsightsConnectionString string

param secret_AppKeyName string

@secure()
param secret_AppKeyValue string

@secure()
param appServiceprincipalId string

@secure()
param funcAppServiceprincipalId string

// @secure()
// param secret_AzureWebJobsStorageValue string

param tenant string

// Define KeyVault accessPolicies
param accessPolicies array = [
  {
    tenantId: tenant
    objectId: appServiceprincipalId
    permissions: {
      keys: [
        'Get'
        'List'
      ]
      secrets: [
        'Get'
        'List'
      ]
    }
  }
  {
    tenantId: tenant
    objectId: funcAppServiceprincipalId
    permissions: {
      keys: [
        'Get'
        'List'
      ]
      secrets: [
        'Get'
        'List'
      ]
    }
  }
]

// Reference Existing resource
resource existing_keyvault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyvaultName
}

// Create KeyVault accessPolicies
resource keyvaultaccessmod 'Microsoft.KeyVault/vaults/accessPolicies@2022-07-01' = {
  name: 'add'
  parent: existing_keyvault
  properties: {
    accessPolicies: accessPolicies
  }
}

// Create KeyVault Secrets
resource secret1 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: secret_AppKeyName
  parent: existing_keyvault
  properties: {
    value: secret_AppKeyValue
  }
}

// Reference Existing resource
resource existing_appService 'Microsoft.Web/sites@2021-03-01' existing = {
  name: webappName
}

// Create Web sites/config 'appsettings' - Web App
resource webSiteAppSettingsStrings 'Microsoft.Web/sites/config@2021-03-01' = {
  name: 'appsettings'
  parent: existing_appService
  properties: {
    WEBSITE_RUN_FROM_PACKAGE: '1'
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsInstrumentationKey
    APPINSIGHTS_PROFILERFEATURE_VERSION: '1.0.0'
    APPINSIGHTS_SNAPSHOTFEATURE_VERSION: '1.0.0'
    APPLICATIONINSIGHTS_CONNECTION_STRING: appInsightsConnectionString
    WebAppUrl: 'https://${existing_appService.name}.azurewebsites.net/'
    ASPNETCORE_ENVIRONMENT: 'Development'
    'AzureMaps:AadAppId': 'a91530fe-cfae-4ca3-b801-9d80da0cb208'
    'AzureMaps:AadTenant': '72f988bf-86f1-41af-91ab-2d7cd011db47'
    'AzureMaps:ClientId': '83707410-e8e2-41d8-9cfc-7c5330fb5168'
    'AzureMaps:AppKey': '@Microsoft.KeyVault(VaultName=${keyvaultName};SecretName=${secret_AppKeyName})'

  }
  dependsOn: [
    secret1
  ]
}



