variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "rg_location" {
  type        = string
  description = "Resource group location"
}

variable "identity_name" {
  type        = string
  description = "Name of the managed identity"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "key_vault_id" {
  type        = string
  description = "ID of the Key Vault to grant access to"
}

variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID"
}

variable "cosmos_db_id" {
  type        = string
  description = "ID of the Cosmos DB to grant access to"
  default     = null
} 