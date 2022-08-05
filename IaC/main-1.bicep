// Deploy Azure infrastructure for FuncApp + monitoring

// Region for all resources
param location string = resourceGroup().location
param createdBy string = 'Randy Pagels'
param costCenter string = '74f644d3e665'

// Variables for Recommended abbreviations for Azure resource types
// https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations
var appInsightsName = 'appi-${uniqueString(resourceGroup().id)}'
var appInsightsWorkspaceName = 'appw-${uniqueString(resourceGroup().id)}'
var appInsightsAlertName = 'responsetime-${uniqueString(resourceGroup().id)}'
var webAppPlanName = 'plan-${uniqueString(resourceGroup().id)}'
var webSiteName = 'app-${uniqueString(resourceGroup().id)}'
var azuremapname = 'maps-${uniqueString(resourceGroup().id)}'

// Tags
var defaultTags = {
  App: 'Azure Maps Blazor'
  CostCenter: costCenter
  CreatedBy: createdBy
}

// Create Application Insights
module appinsightsmod 'main-1-appinsights.bicep' = {
  name: 'appinsightsdeploy'
  params: {
    location: location
    appInsightsName: appInsightsName
    defaultTags: defaultTags
    appInsightsAlertName: appInsightsAlertName
    appInsightsWorkspaceName: appInsightsWorkspaceName
  }
}

// Create Function App
module functionappmod 'main-1-funcapp.bicep' = {
  name: 'functionappdeploy'
  params: {
    location: location
    functionAppServicePlanName: functionAppServicePlanName
    functionAppName: functionAppName
    defaultTags: defaultTags
    appInsightsInstrumentationKey: appinsightsmod.outputs.out_appInsightsInstrumentationKey
    appInsightsConnectionString: appinsightsmod.outputs.out_appInsightsConnectionString
  }
  dependsOn:  [
    appinsightsmod
  ]
  
}

// Output Params used for IaC deployment in pipeline
output out_webSiteName string = webSiteName
// output out_sqlserverName string = sqlserverName
// output out_sqlDBName string = sqlDBName
// output out_sqlserverFQName string = sqldbmod.outputs.sqlserverfullyQualifiedDomainName
// output out_configStoreName string = configStoreName
// output out_appInsightsName string = appInsightsName
output out_functionAppName string = functionAppName
// output out_apiServiceName string = apiServiceName
// output out_loadTestsName string = loadTestsName
// output out_keyvaultName string = keyvaultName
// output out_secretConnectionString string = webappmod.outputs.out_secretConnectionString
// output out_appInsightsApplicationId string = appinsightsmod.outputs.out_appInsightsApplicationId
// output out_appInsightsAPIApplicationId string = appinsightsmod.outputs.out_appInsightsAPIApplicationId
// output out_releaseAnnotationGuidID string = releaseAnnotationGuid
