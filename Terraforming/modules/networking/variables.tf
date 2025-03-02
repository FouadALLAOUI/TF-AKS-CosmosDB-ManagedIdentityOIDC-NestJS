variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "rg_location" {
  type        = string
  description = "Resource group location"
}

variable "vnet_name" {
  type        = string
  description = "Virtual network name"
}

variable "vnet_address_space" {
  type        = string
  description = "Virtual network address space"
}

variable "aks_subnet_cidr" {
  type        = string
  description = "AKS subnet CIDR"
  default     = "10.0.0.0/24"
}

variable "endpoints_subnet_cidr" {
  type        = string
  description = "Private endpoints subnet CIDR"
  default     = "10.0.1.0/24"
}

variable "apim_subnet_cidr" {
  type        = string
  description = "APIM subnet CIDR"
  default     = "10.0.2.0/24"
}

variable "private_dns_zone_name" {
  type        = string
  description = "Private DNS zone name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "vnet_name_frontend" {
  type        = string
  description = "Frontend virtual network name"
  default     = "frontend-vnet"
}

variable "vnet_address_space_frontend" {
  type        = string
  description = "Frontend virtual network address space"
  default     = "17172.26.102.0/23"
}

variable "frontend_subnet_name" {
  type        = string
  description = "Frontend subnet name"
  default     = "frontend-subnet"
}

variable "frontend_subnet_address_space" {
  type        = string
  description = "Frontend subnet address space"
  default     = "17172.26.103.0/24"
}





