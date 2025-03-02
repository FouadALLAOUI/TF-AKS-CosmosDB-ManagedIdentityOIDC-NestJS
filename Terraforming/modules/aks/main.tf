# Log Analytics Workspace for AKS
resource "azurerm_log_analytics_workspace" "aks" {
  name                = "log-${var.aks_cluster_name}-workspace"
  location            = var.rg_location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_analytics_retention_days
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                    = var.aks_cluster_name
  location                = var.rg_location
  resource_group_name     = var.rg_name
  kubernetes_version      = var.kubernetes_version
  dns_prefix              = var.dns_prefix
  private_cluster_enabled = var.private_cluster_enabled

  # Enable Workload Identity
  workload_identity_enabled = true

  # Enable OIDC
  oidc_issuer_enabled = true

  # Network Profile
  network_profile {
    network_plugin      = var.network_plugin
    network_plugin_mode = var.network_plugin_mode
    service_cidr        = var.service_cidr
    dns_service_ip      = var.dns_service_ip
  }

  # Default Node Pool
  default_node_pool {
    name                = "default"
    vm_size             = var.vm_size
    os_sku              = "AzureLinux"
    vnet_subnet_id      = var.aks_subnet_id
    enable_auto_scaling = var.enable_auto_scaling
    min_count           = var.min_node_count
    max_count           = var.max_node_count
  }

  # Identity Configuration
  identity {
    type = "SystemAssigned"
  }

  # Web App Routing
  web_app_routing {
    dns_zone_id = var.private_dns_zone_id
  }

  # Enable app routing with NGINX
  http_application_routing_enabled = true

  # Log Analytics
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.aks.id
  }

  tags = {
    Environment = var.environment
  }
}

# Role Assignment for Network Contributor
resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

# Store kubeconfig locally
resource "local_file" "kubeconfig" {
  content  = azurerm_kubernetes_cluster.aks.kube_config_raw
  filename = "${path.module}/kubeconfig.yaml"
} 