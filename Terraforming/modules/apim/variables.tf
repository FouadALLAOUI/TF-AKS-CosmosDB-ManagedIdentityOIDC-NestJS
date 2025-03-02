variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "rg_location" {
  type        = string
  description = "Resource group location"
}

variable "apim_name" {
  type        = string
  description = "Name of the API Management service"
  default     = "apim-service"
}

variable "publisher_name" {
  type        = string
  description = "Publisher name for the APIM instance"
  default     = "My Company"
}

variable "publisher_email" {
  type        = string
  description = "Publisher email for the APIM instance"
  default     = "admin@mycompany.com"
}

variable "sku_name" {
  type        = string
  description = "SKU name for the APIM instance"
  default     = "Developer_1"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for APIM"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "development"
}

variable "log_retention_days" {
  type        = number
  description = "Number of days to retain logs"
  default     = 30
} 