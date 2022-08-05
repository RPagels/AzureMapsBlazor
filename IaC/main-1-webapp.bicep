param skuName string = 'S1'
param location string = resourceGroup().location
param webAppPlanName string
param webSiteName string
param appInsightsInstrumentationKey string
param appInsightsConnectionString string
param defaultTags object

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: webAppPlanName // app serivce plan name
  location: location // Azure Region
  tags: defaultTags
  properties: {}
  sku: {
    name: skuName
  }
}

resource appService 'Microsoft.Web/sites@2021-03-01' = {
  name: webSiteName // Globally unique app serivce name
  location: location
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
  tags: defaultTags
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
      healthCheckPath: '/healthy'
    }
  }
}

resource webSiteAppSettingsStrings 'Microsoft.Web/sites/config@2021-03-01' = {
  //name: '${webSiteName}/appsettings'
  name: 'appsettings'
  parent: appService
  properties: {
    WEBSITE_RUN_FROM_PACKAGE: '1'
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsInstrumentationKey
    APPINSIGHTS_PROFILERFEATURE_VERSION: '1.0.0'
    APPINSIGHTS_SNAPSHOTFEATURE_VERSION: '1.0.0'
    APPLICATIONINSIGHTS_CONNECTION_STRING: appInsightsConnectionString
    ASPNETCORE_ENVIRONMENT: 'Development'
  }
}

output out_appService string = appService.id
output out_webSiteName string = appService.properties.defaultHostName
output out_appServiceprincipalId string = appService.identity.principalId
