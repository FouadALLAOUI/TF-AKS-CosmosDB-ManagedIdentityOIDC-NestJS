variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "rg_location" {
  type        = string
  description = "Resource group location"
}

variable "aks_cluster_name" {
  type        = string
  description = "AKS cluster name"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}

variable "dns_prefix" {
  type        = string
  description = "DNS prefix"
  default     = "aks"
}

variable "private_cluster_enabled" {
  type        = bool
  description = "Enable private cluster"
  default     = false
}

variable "network_plugin" {
  type        = string
  description = "Network plugin to use"
  default     = "azure"
}

variable "network_plugin_mode" {
  type        = string
  description = "Network plugin mode"
  default     = "overlay"
}

variable "service_cidr" {
  type        = string
  description = "CIDR for Kubernetes services"
  default     = "172.16.0.0/16"
}

variable "dns_service_ip" {
  type        = string
  description = "DNS service IP"
  default     = "172.16.0.10"
}

variable "vm_size" {
  type        = string
  description = "VM size for nodes"
  default     = "Standard_D2_v3"
}

variable "enable_auto_scaling" {
  type        = bool
  description = "Enable cluster autoscaling"
  default     = true
}

variable "min_node_count" {
  type        = number
  description = "Minimum node count"
  default     = 1
}

variable "max_node_count" {
  type        = number
  description = "Maximum node count"
  default     = 3
}

variable "aks_subnet_id" {
  type        = string
  description = "Subnet ID for AKS"
}

variable "private_dns_zone_id" {
  type        = string
  description = "Private DNS Zone ID"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "log_analytics_retention_days" {
  type        = number
  description = "Log retention days"
  default     = 30
} 