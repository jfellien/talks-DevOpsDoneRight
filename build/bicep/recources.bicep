
@minLength(3)
@maxLength(11)
param name string

@minLength(3)
@maxLength(4)
param env string
param location string 

param aspSku string 
param linuxFxVersionDotNet string

@minLength(1)
@maxLength(128)
param sqlDatabaseName string
@secure()
param sqlAdministratorUserName string
@secure()
param sqlAdministratorPassword string

param tags object = {}

// KeyVault
var kvName = 'kv-${name}-${env}'
module keyVault 'modules/key-vault.bicep' = {
  name: 'deploy-${kvName}'
  params: {
    name: kvName
    location: location
    tags: tags
  }
}

// Log Analytics Workspace
var lawName = 'law-${name}-${env}'
module logAnalyticsWorkspace 'modules/log-analytics-workspace.bicep' = {
  name: 'deploy-${lawName}'
  params: {
    name: lawName
    location: location
    tags: tags
  }
}

// App Service Plan
var aspName = 'asp-${name}-${env}'
module appServicePlan 'modules/app-service-plan-linux.bicep' = {
  name: 'deploy-${aspName}'
  params: {
    name: aspName
    location: location
    tags: tags
    sku: aspSku
  }
}

// Application Insights
var appInsightsName = 'appi-${name}-${env}'
module appInsightsManage 'modules/app-insights.bicep' = {
  name: 'deploy-${appInsightsName}'
  params: {
    name: appInsightsName
    location: location
    tags: tags
    workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
  }
}

// SQL Server
var sqlServerName = 'sql-${name}-${env}'
module sqlServer 'modules/sql-server.bicep' = {
  name: 'deploy-${sqlServerName}'
  params: {
    name: sqlServerName
    location: location
    administratorUsername: sqlAdministratorUserName
    administratorPassword: sqlAdministratorPassword
    tags: tags
  }
}

// SQL Database
module sqlServerDatabase 'modules/sql-db.bicep' = {
  name: 'deploy-${sqlDatabaseName}-${env}'
  params: {
      location: location
      sqlServerName: sqlServer.outputs.name
      sqlDbName: sqlDatabaseName
  }
}

var sqlServerConnectionStringSecretName = 'sql-connection-string-${name}-${env}'
module sqlServerConnectionSTringSecret 'modules/key-vault-secret.bicep' = {
  name: 'deploy-${sqlServerConnectionStringSecretName}' 
  params: {
    keyVaultName: keyVault.outputs.name
    name: sqlServerConnectionStringSecretName
    value: 'Server=tcp:${sqlServer.outputs.name}${environment().suffixes.sqlServerHostname},1433;Initial Catalog=${sqlServerDatabase.outputs.name};Persist Security Info=False;User ID=${sqlAdministratorUserName};Password=${sqlAdministratorPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
  }
}

// Web App
var webAppName = 'app-${name}-${env}'
module webApp 'modules/web-app-linux.bicep' = {
  name: 'deploy-${webAppName}'
  params: {
    name: webAppName
    location: location
    tags: tags
    linuxFxVersion: linuxFxVersionDotNet
    appServicePlanId: appServicePlan.outputs.id

    appinsightsConnectionString: appInsightsManage.outputs.connectionString
    appInsightsInstrumentationKey: appInsightsManage.outputs.instrumentationKey

    additionalAppSettings: [
      {
        name: 'SqlServerConnection'
        value: '@Microsoft.KeyVault(SecretUri=${sqlServerConnectionSTringSecret.outputs.uri})'
      }
    ]
  }
}

var webAppKeyVaultSecretReaderRoleAssignmentName = 'web-app-kv-secret-reader-assignment-${env}'
module WebAppKeyVaultSecretReaderRoleAssignment 'modules/key-vault-role-assignment.bicep' = {
  name: 'deploy-${webAppKeyVaultSecretReaderRoleAssignmentName}'
  params: {
    keyVaultName: keyVault.outputs.name
    principalId: webApp.outputs.principalId
    roleId: '4633458b-17de-408a-b874-0445c86b69e6' // Key Vault Secrets User
  }
}
