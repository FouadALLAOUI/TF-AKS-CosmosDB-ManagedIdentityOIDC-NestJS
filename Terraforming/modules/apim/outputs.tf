output "apim_id" {
  description = "The ID of the API Management service"
  value       = azurerm_api_management.apim.id
}

output "apim_name" {
  description = "The name of the API Management service"
  value       = azurerm_api_management.apim.name
}

output "gateway_url" {
  description = "The gateway URL of the API Management service"
  value       = azurerm_api_management.apim.gateway_url
}

output "management_api_url" {
  description = "The management API URL of the API Management service"
  value       = azurerm_api_management.apim.management_api_url
}

output "portal_url" {
  description = "The publisher portal URL of the API Management service"
  value       = azurerm_api_management.apim.portal_url
}

output "public_ip_addresses" {
  description = "The public IP addresses of the API Management service"
  value       = azurerm_api_management.apim.public_ip_addresses
}

output "private_ip_addresses" {
  description = "The private IP addresses of the API Management service"
  value       = azurerm_api_management.apim.private_ip_addresses
} 