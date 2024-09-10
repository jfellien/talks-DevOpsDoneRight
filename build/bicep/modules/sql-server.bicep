param location string
@minLength(1)
@maxLength(63)
param name string
param administratorUsername string
@secure()
param administratorPassword string
param tags object = {}

resource sqlServer 'Microsoft.Sql/servers@2021-05-01-preview' = {
  name: name
  location: location
  properties: {
    administratorLogin: administratorUsername
    administratorLoginPassword: administratorPassword
  }
  resource fwRule 'firewallRules' = {
    name: '${name}-fwAzure'
    properties: {
      startIpAddress: '0.0.0.0'
      endIpAddress: '0.0.0.0'
    }
  }
  tags: tags  
}

output name string = sqlServer.name
output hostname string = sqlServer.properties.fullyQualifiedDomainName
