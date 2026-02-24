@description('Azure region for management metadata (Static Web Apps are globally distributed).')
param location string = resourceGroup().location

@description('GitHub repo URL, e.g. https://github.com/<user>/<repo>')
param repositoryUrl string

@description('Deployment environment, e.g. dev, staging, prod')
param environment string

@description('GitHub branch to deploy from, e.g. main')
param branch string 

@secure()
@description('GitHub Personal Access Token (PAT) with repo + workflow + write:packages scopes.')
param repositoryToken string ///Helpful for CI/CD deployments, but can be left empty for manual deployments where the user will authenticate with GitHub during deployment.
@description('SKU: Free or Standard')
@allowed([
  'Free'
  'Standard'
])
param skuName string 

@description('Project name for tagging and naming purposes.')
param projectName string 

var staticWebAppName = '${projectName}-${environment}-webapp'

resource GPT 'Microsoft.Web/staticSites@2025-03-01' = {
  name: staticWebAppName
  location: location
  sku: {
    name: skuName
    tier: skuName
  }
  properties: {
    provider: 'GitHub'
    repositoryUrl: repositoryUrl
    branch: branch
    repositoryToken: repositoryToken

    // Build settings used by the generated GitHub workflow
    buildProperties: {
      appLocation: '/'
      apiLocation: ''
      outputLocation: ''  // no build output folder since this is plain HTML
      skipGithubActionWorkflowGeneration: false
    }

    allowConfigFileUpdates: true
  }
}

output staticWebAppUrl string = 'https://${GPT.properties.defaultHostname}'

