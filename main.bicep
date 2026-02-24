// Main entry point for GPT static web app deployment
// Use parameters/dev.bicepparam to configure deployment settings

param environment string
param projectName string
param repositoryUrl string
param branch string 
@secure()
param repositoryToken string
param skuName string 

module webapp './Infra/webapp.bicep' = {
  name: 'webapp-deployment'
  params: {
    environment: environment
    projectName: projectName
    location: resourceGroup().location
    repositoryUrl: repositoryUrl
    branch: branch
    repositoryToken: repositoryToken
    skuName: skuName
  }
}

output staticWebAppUrl string = webapp.outputs.staticWebAppUrl
