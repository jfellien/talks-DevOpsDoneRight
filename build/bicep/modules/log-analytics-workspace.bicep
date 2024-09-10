param name string
param location string
param tags object

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: name
  location: location
  tags: tags
}

output name string = workspace.name
output resourceId string = resourceId('Microsoft.OperationalInsights/workspaces', name)
