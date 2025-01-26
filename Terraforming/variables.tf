variable "rg_name" {
  type        = string
  description = "Name of the Resource Group"
  default     = "minimal_infra_auth"
}

variable "rg_location" {
  type        = string
  description = "Azure location for the Resource Group"
  default     = "West Europe"
}

variable "backend_vnet_name" {
  type        = string
  description = "Backend virtual network name"
  default     = "backend_vnet"
}

variable "backend_vnet_address_space" {
  type        = string
  description = "Vertual network address space"
  default     = "10.0.0.0/16"
}

variable "aks_subnet_name" {
  type        = string
  description = "AKS subnet name"
  default     = "aks_subnet"
}

variable "aks_subnet_cidr" {
  type        = string
  description = "AKS subnet ip range"
  default     = "10.0.0.0/24"
}

variable "private_endpoints_subnet_name" {
  type        = string
  description = "Private endpoints subnet name"
  default     = "private_endpoints_subnet"
}

variable "endpoints_subnet_cidr" {
  type        = string
  description = "Private endpoints subnet ip range"
  default     = "10.0.1.0/24"
}

variable "private_dns_zone_name" {
  type        = string
  description = "Private DNS Zone name"
  default     = "privatelink.nostradamusdns.azure.com"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}


################## AKS Variables ##################

variable "aks_cluster_name" {
  type        = string
  description = "AKS cluster name"
  default     = "aks_cluster"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
  default     = "1.30.0"
}

variable "dns_prefix" {
  type        = string
  description = "DNS prefix"
  default     = "infranostradaks"
}

variable "private_cluster_enabled" {
  type        = bool
  description = "Whether to enable private cluster"
  default     = false
}

variable "enable_auto_scaling" {
  type        = bool
  description = "Whether to enable auto scaling"
  default     = true
}

variable "network_plugin" {
  type        = string
  description = "Network plugin"
  default     = "azure"
}

variable "network_plugin_mode" {
  type        = string
  description = "Network plugin mode"
  default     = "overlay"
}

variable "node_count" {
  type        = number
  description = "Node count"
  default     = 1
}

variable "vm_size" {
  type        = string
  description = "VM size"
  default     = "Standard_D2_v3"
}


variable "min_node_count" {
  type        = number
  description = "Min node count"
  default     = 1
}

variable "max_node_count" {
  type        = number
  description = "Max node count"
  default     = 2
}

# Add new variable for Log Analytics
variable "log_analytics_retention_days" {
  type        = number
  description = "Number of days to retain logs"
  default     = 30
}

# Add these new variables after the network related variables
variable "service_cidr" {
  type        = string
  description = "CIDR range for kubernetes service"
  default     = "172.16.0.0/16" # Non-overlapping range with VNet
}

variable "dns_service_ip" {
  type        = string
  description = "DNS service IP address"
  default     = "172.16.0.10" # Must be within service_cidr range
}

variable "docker_bridge_cidr" {
  type        = string
  description = "Docker bridge CIDR"
  default     = "172.17.0.0/16" # Non-overlapping with both VNet and service_cidr
}


################## Cosmos DB NoSQL Variables ##################

variable "db_account_name" {
  type        = string
  description = "Cosmos DB account name"
  default     = "nostradamus-cosmosdb"
}

variable "database_name" {
  type        = string
  description = "Cosmos DB database name"
  default     = "nostradamus-rio"
}

variable "sql_container_name" {
  type        = string
  description = "SQL container name"
  default     = "containerdb-authproject"
}



































