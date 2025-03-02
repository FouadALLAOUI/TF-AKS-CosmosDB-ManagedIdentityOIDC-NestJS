# User Assigned Managed Identity
resource "azurerm_user_assigned_identity" "managed_identity" {
  name                = var.identity_name
  resource_group_name = var.rg_name
  location            = var.rg_location

  tags = {
    Environment = var.environment
  }
}

# Role assignments for the Managed Identity
resource "azurerm_role_assignment" "key_vault_access" {
  scope                = var.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.managed_identity.principal_id
}

resource "azurerm_role_assignment" "cosmos_db_access" {
  count                = var.cosmos_db_id != null ? 1 : 0
  scope                = var.cosmos_db_id
  role_definition_name = "Cosmos DB Built-in Data Contributor"
  principal_id         = azurerm_user_assigned_identity.managed_identity.principal_id
}

# Key Vault Access Policy
resource "azurerm_key_vault_access_policy" "managed_identity_policy" {
  key_vault_id = var.key_vault_id
  tenant_id    = var.tenant_id
  object_id    = azurerm_user_assigned_identity.managed_identity.principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
} 