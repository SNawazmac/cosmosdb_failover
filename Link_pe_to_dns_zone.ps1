param(
[Parameter(Mandatory=$true)][string]$private_dns_zone_subscription_Id,           #Enter the Subscription Id where the Private dns zone is existing
[Parameter(Mandatory=$true)][string]$private_dns_zone_resource_group_name,        #Enter the resourcegroup name of the Private dns zone
[Parameter(Mandatory=$true)][string]$cosmosdb_private_dns_zone_name,               #Enter the name of the private dns zone
[Parameter(Mandatory=$true)][string]$cosmosdb_private_dns_zone_global_record_name,
[Parameter(Mandatory=$true)][string]$cosmosdb_private_dns_zone_primary_region_record_name,
[Parameter(Mandatory=$true)][string]$cosmosdb_private_dns_zone_secondary_region_record_name,             #Enter the name of the recordname to be updated
[Parameter(Mandatory=$true)][string]$cosmosdb_global_endpoint_primary_region_IP,                   #Enter the new IP to be added
[Parameter(Mandatory=$true)][string]$cosmosdb_global_endpoint_secondary_region_IP,                   #Enter the old IP to be removed
[Parameter(Mandatory=$true)][string]$cosmosdb_primary_endpoint_primary_region_IP,
[Parameter(Mandatory=$true)][string]$cosmosdb_primary_endpoint_secondary_region_IP,
[Parameter(Mandatory=$true)][string]$cosmosdb_secondary_endpoint_primary_region_IP,
[Parameter(Mandatory=$true)][string]$cosmosdb_secondary_endpoint_secondary_region_IP
)

#The below command sets authentication information for cmdlets that run in the current session
Set-AzContext -Subscription $private_dns_zone_subscription_Id

#The below commands adds the new IP to the DNS recordset
$RecordSet_global = Get-AzPrivateDnsRecordSet -ResourceGroupName $private_dns_zone_resource_group_name -ZoneName $cosmosdb_private_dns_zone_name -Name $cosmosdb_private_dns_zone_global_record_name -RecordType A
$RecordSet_primary_region = Get-AzPrivateDnsRecordSet -ResourceGroupName $private_dns_zone_resource_group_name -ZoneName $cosmosdb_private_dns_zone_name -Name $cosmosdb_private_dns_zone_primary_region_record_name -RecordType A
$RecordSet_secondary_region = Get-AzPrivateDnsRecordSet -ResourceGroupName $private_dns_zone_resource_group_name -ZoneName $cosmosdb_private_dns_zone_name -Name $cosmosdb_private_dns_zone_secondary_region_record_name -RecordType A

Add-AzPrivateDnsRecordConfig -RecordSet $RecordSet_global -Ipv4Address $cosmosdb_global_endpoint_secondary_region_IP
Add-AzPrivateDnsRecordConfig -RecordSet $RecordSet_primary_region -Ipv4Address $cosmosdb_primary_endpoint_secondary_region_IP
Add-AzPrivateDnsRecordConfig -RecordSet $RecordSet_secondary_region -Ipv4Address $cosmosdb_secondary_endpoint_secondary_region_IP
 
Set-AzPrivateDnsRecordSet -RecordSet $RecordSet_global
Set-AzPrivateDnsRecordSet -RecordSet $RecordSet_primary_region
Set-AzPrivateDnsRecordSet -RecordSet $RecordSet_secondary_region

#The below commands removes the old IP from the DNS recordset
#$RecordSet = Get-AzPrivateDnsRecordSet -Name $container_registry_private_dns_zone_record_name -RecordType A -ResourceGroupName $private_dns_zone_resource_group_name -ZoneName $container_registry_private_dns_zone_name
$RecordSet_global = Get-AzPrivateDnsRecordSet -ResourceGroupName $private_dns_zone_resource_group_name -ZoneName $cosmosdb_private_dns_zone_name -Name $cosmosdb_private_dns_zone_global_record_name -RecordType A
$RecordSet_primary_region = Get-AzPrivateDnsRecordSet -ResourceGroupName $private_dns_zone_resource_group_name -ZoneName $cosmosdb_private_dns_zone_name -Name $cosmosdb_private_dns_zone_primary_region_record_name -RecordType A
$RecordSet_secondary_region = Get-AzPrivateDnsRecordSet -ResourceGroupName $private_dns_zone_resource_group_name -ZoneName $cosmosdb_private_dns_zone_name -Name $cosmosdb_private_dns_zone_secondary_region_record_name -RecordType A

Remove-AzPrivateDnsRecordConfig -RecordSet $RecordSet_global -Ipv4Address $cosmosdb_global_endpoint_primary_region_IP
Remove-AzPrivateDnsRecordConfig -RecordSet $RecordSet_primary_region -Ipv4Address $cosmosdb_primary_endpoint_primary_region_IP
Remove-AzPrivateDnsRecordConfig -RecordSet $RecordSet_secondary_region -Ipv4Address $cosmosdb_secondary_endpoint_primary_region_IP

Set-AzPrivateDnsRecordSet -RecordSet $RecordSet_global
Set-AzPrivateDnsRecordSet -RecordSet $RecordSet_primary_region
Set-AzPrivateDnsRecordSet -RecordSet $RecordSet_secondary_region
