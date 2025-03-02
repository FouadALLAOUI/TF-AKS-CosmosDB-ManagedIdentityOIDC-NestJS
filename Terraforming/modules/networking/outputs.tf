output "vnet_id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.vnet_backend.id
}

output "vnet_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.vnet_backend.name
}

output "aks_subnet_id" {
  description = "The ID of the AKS subnet"
  value       = azurerm_subnet.aks_subnet.id
}

output "private_endpoints_subnet_id" {
  description = "The ID of the private endpoints subnet"
  value       = azurerm_subnet.private_endpoints_subnet.id
}

output "apim_subnet_id" {
  description = "The ID of the APIM subnet"
  value       = azurerm_subnet.apim_subnet.id
}

output "private_dns_zone_id" {
  description = "The ID of the private DNS zone"
  value       = azurerm_private_dns_zone.private_dns.id
} 