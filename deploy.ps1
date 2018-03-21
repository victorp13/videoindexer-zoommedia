## REQUIRED PARAMETERS
# Syntax: ".\deploy.ps1 -videoindexerkey xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -zoommediatoken yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"

# Video Indexer and Zoom Media keys
param (
    [string]$videoindexerkey,
    [string]$zoommediatoken
 )

# Resource location and naming
$location="West Europe"
$randomvalue=$(Get-Random)
$resourcegroup="rg" + $randomvalue
$storageaccountname="stor" + $randomvalue
$containername="uploads"
$connectionname="conn" + $randomvalue
$logicappname="logic" + $randomvalue

# Creating Resource Group
New-AzureRmResourceGroup -Name $resourcegroup -Location $location

# Creating Storage Account and Container
New-AzureRmStorageAccount -ResourceGroupName $resourceGroup -Name $storageaccountname -Location $location -SkuName Standard_LRS
Set-AzureRmCurrentStorageAccount -StorageAccountName $storageaccountname -ResourceGroupName $resourceGroup
New-AzureStorageContainer -Name $containername

# Retrieving Subscription ID
$subscriptionId = (Get-AzureRmContext).Subscription.Id

# Retrieving Storage Account Key
$storageaccountkey = (Get-AzureRmStorageAccountKey -ResourceGroupName $resourcegroup -Name $storageaccountname).Value[0]

# Creating API Connection and Logic App
New-AzureRmResourceGroupDeployment -Name APIConnectionDeployment -ResourceGroupName $resourcegroup `
    -TemplateFile .\template.json `
    -subscriptionId $subscriptionId `
    -location $location `
    -connectionName $connectionname `
    -logicapp_name $logicappname `
    -storageAccountName $storageaccountname `
    -storageAccountKey $storageaccountkey `
    -containerName $containername `
    -videoindexerkey $videoindexerkey `
    -zoommediatoken $zoommediatoken