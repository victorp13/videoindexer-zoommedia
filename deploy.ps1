## REQUIRED TO CHANGE
# Video Indexer and Zoom Media keys; need to be set here or via parameters
param (
    [string]$videoindexerkey="xxxxxxxxxxxxxxxxxxxxxx",
    [string]$zoommediatoken="yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"
 )

# Resource location and naming
$location="West Europe"
$randomvalue=$(Get-Random)
$resourcegroup="rg" + $randomvalue
$storageaccountname="stor" + $randomvalue
$connectionname="conn" + $randomvalue
$logicappname="logic" + $randomvalue

# Creating Resource Group
New-AzureRmResourceGroup -Name $resourcegroup -Location $location

# Creating Storage Account and Container called "uploads"
New-AzureRmStorageAccount -ResourceGroupName $resourceGroup -Name $storageaccountname -Location $location -SkuName Standard_LRS
Set-AzureRmCurrentStorageAccount -StorageAccountName $storageaccountname -ResourceGroupName $resourceGroup
New-AzureStorageContainer -Name "uploads"

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
    -videoindexerkey $videoindexerkey `
    -zoommediatoken $zoommediatoken