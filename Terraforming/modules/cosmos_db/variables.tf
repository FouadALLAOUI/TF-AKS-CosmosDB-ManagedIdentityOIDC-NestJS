variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "rg_location" {
  type        = string
  description = "Resource group location"
}

variable "db_account_name" {
  type        = string
  description = "Cosmos DB account name"
}

variable "database_name" {
  type        = string
  description = "Database name"
}

variable "sql_container_name" {
  type        = string
  description = "SQL container name"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for private endpoint"
}

variable "private_dns_zone_id" {
  type        = string
  description = "Private DNS Zone ID"
}

variable "private_dns_zone_name" {
  type        = string
  description = "Private DNS Zone name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "ip_range_filter" {
  type        = string
  description = "IP range filter"
  default     = "0.0.0.0"
} 