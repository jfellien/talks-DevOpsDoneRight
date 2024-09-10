targetScope = 'subscription'

param resourceGroupName string

@minLength(3)
@maxLength(11)
param name string

@minLength(3)
@maxLength(4)
param env string
param location string = 'germanywestcentral'

@minLength(1)
@maxLength(128)
param sqlDatabaseName string = name
@secure()
param sqlAdministratorUserName string
@secure()
param sqlAdministratorPassword string

param aspSku string = 'P0V3'
param linuxFxVersionDotNet string = 'DOTNETCORE|8.0'

var tags = {
  env: env
  product: 'DevOpsDoneRight Sample'
}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module resources 'recources.bicep' = {
  name: 'deploy-${name}-${env}'
  scope: resourceGroup
  params: {
    name: name
    env: env
    location: location
    aspSku: aspSku
    linuxFxVersionDotNet: linuxFxVersionDotNet
    sqlDatabaseName: sqlDatabaseName
    sqlAdministratorUserName: sqlAdministratorUserName
    sqlAdministratorPassword: sqlAdministratorPassword
    tags: tags
  }
} 
