output "identity_id" {
  description = "The ID of the managed identity"
  value       = azurerm_user_assigned_identity.managed_identity.id
}

output "principal_id" {
  description = "The Principal ID of the managed identity"
  value       = azurerm_user_assigned_identity.managed_identity.principal_id
}

output "client_id" {
  description = "The Client ID of the managed identity"
  value       = azurerm_user_assigned_identity.managed_identity.client_id
} 