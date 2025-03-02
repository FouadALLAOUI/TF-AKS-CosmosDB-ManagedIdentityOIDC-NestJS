################## Network Outputs ##################
/*
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "vnet_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.vnet_backend.name
}

output "private_endpoints_subnet_id" {
  description = "The ID of the Private Endpoints subnet"
  value       = azurerm_subnet.private_endpoints_subnet.id
}

################## AKS Outputs ##################

output "aks_id" {
  description = "The ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks_back.id
}

output "aks_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks_back.name
}

output "aks_private_fqdn" {
  description = "The private FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks_back.private_fqdn
}

output "kube_config_raw" {
  description = "Raw kubeconfig content"
  value       = azurerm_kubernetes_cluster.aks_back.kube_config_raw
  sensitive   = true
}

output "oidc_issuer_url" {
  description = "The OIDC issuer URL"
  value       = azurerm_kubernetes_cluster.aks_back.oidc_issuer_url
}


################## Cosmos DB Outputs ##################

output "cosmosdb_id" {
  description = "The ID of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.db_account.id
}

output "cosmosdb_endpoint" {
  description = "The endpoint of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.db_account.endpoint
}

output "cosmosdb_private_endpoint_ip" {
  description = "The private IP address of the Cosmos DB private endpoint"
  value       = azurerm_private_endpoint.cosmosdb_private_endpoint.private_service_connection[0].private_ip_address
}

output "cosmosdb_connection_string" {
  description = "The primary SQL connection string for the Cosmos DB account"
  value       = azurerm_cosmosdb_account.db_account.primary_sql_connection_string
  sensitive   = true
}

################## Private DNS Outputs ##################

output "private_dns_zone_id" {
  description = "The ID of the private DNS zone"
  value       = azurerm_private_dns_zone.privatedns_aks.id
}

output "private_dns_zone_name" {
  description = "The name of the private DNS zone"
  value       = azurerm_private_dns_zone.privatedns_aks.name
}

output "cosmosdb_private_dns_a_record" {
  description = "The A record for Cosmos DB private endpoint"
  value       = azurerm_private_dns_a_record.cosmosdb_private_dns_a_record.fqdn
}

# Output the ID of the backend virtual network
output "backend_vnet_id" {
  description = "The ID of the backend virtual network (vnet_backend)."
  value       = azurerm_virtual_network.vnet_backend.id
}

# Output the name of the backend virtual network
output "backend_vnet_name" {
  description = "The name of the backend virtual network (vnet_backend)."
  value       = azurerm_virtual_network.vnet_backend.name
}

# Output the subnet ID for AKS
output "aks_subnet_id" {
  description = "The ID of the AKS subnet within the backend virtual network."
  value       = azurerm_subnet.aks_subnet.id
}

################## Outputs for AKS ##################

# Output the principal ID of the AKS system-assigned identity
output "aks_principal_id" {
  description = "The principal ID of the AKS cluster's system-assigned managed identity."
  value       = azurerm_kubernetes_cluster.aks_back.identity[0].principal_id
}

# Output the default node pool name
output "default_node_pool_name" {
  description = "The name of the default node pool."
  value       = azurerm_kubernetes_cluster.aks_back.default_node_pool[0].name
}

# Output the VM size used for the default node pool
output "default_node_pool_vm_size" {
  description = "The VM size used for the default node pool."
  value       = azurerm_kubernetes_cluster.aks_back.default_node_pool[0].vm_size
}

# Output the node count for the default node pool
output "default_node_pool_count" {
  description = "The node count for the default node pool."
  value       = azurerm_kubernetes_cluster.aks_back.default_node_pool[0].node_count
}

# Output the AKS cluster's DNS service IP address (if using a private cluster)
output "aks_private_dns_service_ip" {
  description = "The DNS service IP address for the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks_back.dns_prefix_private_cluster
}
*/
/*
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "resource_group_location" {
  description = "The location of the resource group"
  value       = azurerm_resource_group.rg.location
}

# Networking outputs
output "vnet_id" {
  description = "The ID of the virtual network"
  value       = module.networking.vnet_id
}

# AKS outputs
output "aks_id" {
  description = "The ID of the AKS cluster"
  value       = module.aks.cluster_id
}

output "aks_fqdn" {
  description = "The FQDN of the AKS cluster"
  value       = module.aks.cluster_fqdn
}

# Cosmos DB outputs
output "cosmos_db_endpoint" {
  description = "The endpoint of the Cosmos DB account"
  value       = module.cosmos_db.endpoint
}

# APIM outputs
output "apim_gateway_url" {
  description = "The gateway URL of the API Management service"
  value       = module.apim.gateway_url
}

# Key Vault outputs
output "key_vault_uri" {
  description = "The URI of the Key Vault"
  value       = module.keyvault.vault_uri
}


*/

