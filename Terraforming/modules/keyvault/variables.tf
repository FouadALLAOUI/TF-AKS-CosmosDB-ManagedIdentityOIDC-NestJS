variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "rg_location" {
  type        = string
  description = "Resource group location"
}

variable "key_vault_name" {
  type        = string
  description = "Name of the Key Vault"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for private endpoint"
}

variable "allowed_ip_ranges" {
  type        = list(string)
  description = "List of IP ranges allowed to access Key Vault"
  default     = []
}

variable "log_retention_days" {
  type        = number
  description = "Number of days to retain logs"
  default     = 30
} 