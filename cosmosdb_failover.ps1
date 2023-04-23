param(
[Parameter(Mandatory=$true)][string]$cosmosdb_resource_group_name, 
[Parameter(Mandatory=$true)][string]$cosmosdb_name,
[Parameter(Mandatory=$true)][string]$cosmosdb_primary_region,
[Parameter(Mandatory=$true)][string]$cosmosdb_secondary_region
)                                                          

Update-AzCosmosDBAccountFailoverPriority -ResourceGroupName $cosmosdb_resource_group_name -Name $cosmosdb_name -FailoverPolicy $cosmosdb_primary_region, $cosmosdb_secondary_region
