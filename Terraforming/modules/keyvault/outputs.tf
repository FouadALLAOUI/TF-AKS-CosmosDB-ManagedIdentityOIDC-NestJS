output "key_vault_id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.vault.id
}

output "key_vault_name" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.vault.name
}

output "vault_uri" {
  description = "The URI of the Key Vault"
  value       = azurerm_key_vault.vault.vault_uri
}

output "private_endpoint_ip" {
  description = "The private IP of the Key Vault endpoint"
  value       = azurerm_private_endpoint.kv_endpoint.private_service_connection[0].private_ip_address
}

output "tenant_id" {
  description = "The tenant ID used in Key Vault"
  value       = data.azurerm_client_config.current.tenant_id
} 