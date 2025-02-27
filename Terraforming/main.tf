resource "azurerm_resource_group" "apim_resource" {
  name     = "rg_apim"
  location = "eastus"
}

# External API Management
resource "azurerm_api_management" "external_apim" {
  name                = "external-apim-demo"
  location            = azurerm_resource_group.apim_resource.location
  resource_group_name = azurerm_resource_group.apim_resource.name
  publisher_name      = "Demo Company"
  publisher_email     = "admin@democompany.com"

  sku_name = "Developer_1" # You can change to Premium_1 for production

  virtual_network_type = "External"

  # Add virtual network configuration
  virtual_network_configuration {
    subnet_id = azurerm_subnet.apim_subnet.id
  }

  # Public IP configuration
  public_ip_address_id = azurerm_public_ip.apim_public_ip.id

  protocols {
    enable_http2 = true
  }

  security {
    enable_backend_ssl30 = false
  }
}

# Public IP for APIM
resource "azurerm_public_ip" "apim_public_ip" {
  name                = "apim-public-ip"
  resource_group_name = azurerm_resource_group.apim_resource.name
  location            = azurerm_resource_group.apim_resource.location
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "external-apim-demo-${lower(replace(azurerm_resource_group.apim_resource.name, "_", "-"))}"

  tags = {
    environment = "production"
    purpose     = "APIM"
  }
}

# NSG for APIM
resource "azurerm_network_security_group" "apim_nsg" {
  name                = "apim-nsg"
  location            = azurerm_resource_group.apim_resource.location
  resource_group_name = azurerm_resource_group.apim_resource.name

  security_rule {
    name                       = "Allow-APIM-Management-Endpoint"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3443"
    source_address_prefix      = "ApiManagement"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "VirtualNetwork"
  }
}

# Create a diagnostic setting for APIM
resource "azurerm_monitor_diagnostic_setting" "apim_diagnostics" {
  name                       = "apim-diagnostics"
  target_resource_id         = azurerm_api_management.external_apim.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.apim_logs.id

  enabled_log {
    category = "GatewayLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Log Analytics Workspace for APIM
resource "azurerm_log_analytics_workspace" "apim_logs" {
  name                = "apim-logs-workspace"
  location            = azurerm_resource_group.apim_resource.location
  resource_group_name = azurerm_resource_group.apim_resource.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Add API configuration
resource "azurerm_api_management_api" "example_api" {
  name                = "example-api"
  resource_group_name = azurerm_resource_group.apim_resource.name
  api_management_name = azurerm_api_management.external_apim.name
  revision            = "1"
  display_name        = "Example API"
  path                = "api"
  protocols           = ["https"]

  # Option 1: Remove the import block if you don't have a swagger file
  # Option 2: Use inline OpenAPI specification
  import {
    content_format = "openapi+json"
    content_value = jsonencode({
      openapi = "3.0.1"
      info = {
        title   = "Example API"
        version = "1.0"
      }
      paths = {
        "/hello" = {
          get = {
            responses = {
              "200" = {
                description = "OK"
              }
            }
          }
        }
      }
    })
  }
}

# Add API policy
resource "azurerm_api_management_api_policy" "example_policy" {
  api_name            = azurerm_api_management_api.example_api.name
  api_management_name = azurerm_api_management.external_apim.name
  resource_group_name = azurerm_resource_group.apim_resource.name

  xml_content = <<XML
<policies>
  <inbound>
    <base />
    <set-backend-service base-url="http://172.26.103.103" />
  </inbound>
</policies>
XML
}

# Create VNET for APIM
resource "azurerm_virtual_network" "apim_vnet" {
  name                = "apim-vnet"
  resource_group_name = azurerm_resource_group.apim_resource.name
  location            = azurerm_resource_group.apim_resource.location
  address_space       = ["10.0.0.0/16"]
}

# Create Subnet for APIM
resource "azurerm_subnet" "apim_subnet" {
  name                 = "apim-subnet"
  resource_group_name  = azurerm_resource_group.apim_resource.name
  virtual_network_name = azurerm_virtual_network.apim_vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  # Required service endpoints for APIM
  service_endpoints = [
    "Microsoft.Web",
    "Microsoft.KeyVault",
    "Microsoft.ServiceBus"
  ]
}

# Associate NSG with APIM subnet
resource "azurerm_subnet_network_security_group_association" "apim_nsg_association" {
  subnet_id                 = azurerm_subnet.apim_subnet.id
  network_security_group_id = azurerm_network_security_group.apim_nsg.id
}




/*
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.rg_location
}

# Backend Virtual Network for Internal Services (APIM, AKS, etc.)
resource "azurerm_virtual_network" "vnet_backend" {
  name                = var.backend_vnet_name
  address_space       = [var.backend_vnet_address_space]
  location            = var.rg_location
  resource_group_name = var.rg_name

  depends_on = [
    azurerm_resource_group.rg
  ]
}

# Subnet for AKS within Backend VNET
resource "azurerm_subnet" "aks_subnet" {
  name                 = var.aks_subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet_backend.name
  address_prefixes     = [var.aks_subnet_cidr]

  depends_on = [
    azurerm_virtual_network.vnet_backend
  ]
}

# Subnet for Private Endpoints within Backend VNET
resource "azurerm_subnet" "private_endpoints_subnet" {
  name                 = var.private_endpoints_subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet_backend.name
  address_prefixes     = [var.endpoints_subnet_cidr]

  depends_on = [
    azurerm_virtual_network.vnet_backend
  ]
}

# Private DNS Zone for AKS 
resource "azurerm_private_dns_zone" "privatedns_aks" {
  name                = var.private_dns_zone_name
  resource_group_name = var.rg_name

  tags = {
    environment = var.environment
    purpose     = "AKSPrivateDNS"
  }

  depends_on = [
    azurerm_resource_group.rg
  ]
}

# Linking Private DNS Zone to Backend VNET
resource "azurerm_private_dns_zone_virtual_network_link" "dns_link_backend" {
  name                  = "dns-backend-link"
  resource_group_name   = var.rg_name
  virtual_network_id    = azurerm_virtual_network.vnet_backend.id
  private_dns_zone_name = azurerm_private_dns_zone.privatedns_aks.name

  depends_on = [
    azurerm_private_dns_zone.privatedns_aks,
    azurerm_virtual_network.vnet_backend
  ]
}

# NSG for AKS subnet
resource "azurerm_network_security_group" "aks_nsg" {
  name                = "${var.aks_subnet_name}-nsg"
  location            = var.rg_location
  resource_group_name = var.rg_name

  depends_on = [
    azurerm_resource_group.rg
  ]
}

# NSG Association
resource "azurerm_subnet_network_security_group_association" "aks_nsg_association" {
  subnet_id                 = azurerm_subnet.aks_subnet.id
  network_security_group_id = azurerm_network_security_group.aks_nsg.id

  depends_on = [
    azurerm_subnet.aks_subnet,
    azurerm_network_security_group.aks_nsg
  ]
}

# Add these rules to your existing NSG
resource "azurerm_network_security_rule" "allow_lb" {
  name                        = "allow_lb"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.aks_nsg.name
}

resource "azurerm_network_security_rule" "allow_internal" {
  name                        = "allow_internal"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.aks_nsg.name
}

################## AKS ##################

# Azure Kubernetes Service (AKS) cluster configuration
resource "azurerm_kubernetes_cluster" "aks_back" {
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

  # Network Profile Configuration
  network_profile {
    network_plugin      = var.network_plugin
    network_plugin_mode = var.network_plugin_mode
    service_cidr        = var.service_cidr
    dns_service_ip      = var.dns_service_ip
    //docker_bridge_cidr  = var.docker_bridge_cidr
  }

  # Default Node Pool Configuration
  default_node_pool {
    name                = "default"
    vm_size             = var.vm_size
    os_sku              = "AzureLinux"
    vnet_subnet_id      = azurerm_subnet.aks_subnet.id
    enable_auto_scaling = var.enable_auto_scaling
    min_count           = var.min_node_count
    max_count           = var.max_node_count
  }

  # Identity Configuration
  identity {
    type = "SystemAssigned"
  }

  # Web App Routing configuration
  web_app_routing {
    dns_zone_ids = [azurerm_private_dns_zone.privatedns_aks.id]
  }

  # Add this to enable app routing with NGINX
  http_application_routing_enabled = true

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.aks.id
  }

  tags = {
    Environment = "test"
  }

  depends_on = [
    azurerm_subnet.aks_subnet,
    azurerm_log_analytics_workspace.aks,
    azurerm_private_dns_zone.privatedns_aks,
    azurerm_subnet_network_security_group_association.aks_nsg_association
  ]
}

# Add after the AKS cluster resource
resource "azurerm_log_analytics_workspace" "aks" {
  name                = "log${replace(var.aks_cluster_name, "_", "-")}workspace"
  location            = var.rg_location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  depends_on = [
    azurerm_resource_group.rg
  ]
}

# Role Assignment for AKS Network Contributor Role
resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = azurerm_kubernetes_cluster.aks_back.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks_back.identity[0].principal_id

  depends_on = [
    azurerm_kubernetes_cluster.aks_back
  ]
}

# Storing kubeconfig file locally for AKS cluster access
resource "local_file" "kubeconfig" {
  content  = azurerm_kubernetes_cluster.aks_back.kube_config_raw
  filename = "${path.module}/kubeconfig.yaml"

  depends_on = [
    azurerm_kubernetes_cluster.aks_back
  ]
}

# Run the az command to change the kubeconfig file
resource "null_resource" "apply_kubeconfig" {
  provisioner "local-exec" {
    command = "az aks get-credentials --resource-group ${var.rg_name} --name ${var.aks_cluster_name} --overwrite-existing"
  }

  depends_on = [
    azurerm_kubernetes_cluster.aks_back,
    local_file.kubeconfig
  ]
}


################## Cosmos DB NoSQL - Document DB ##################

resource "random_integer" "ri" {
  min = 10
  max = 100
}

resource "azurerm_cosmosdb_account" "db_account" {
  name                             = "${var.db_account_name}-${random_integer.ri.result}"
  location                         = var.rg_location
  resource_group_name              = var.rg_name
  offer_type                       = "Standard"
  kind                             = "GlobalDocumentDB"
  automatic_failover_enabled       = false
  multiple_write_locations_enabled = false

  consistency_policy {
    consistency_level = "Session"
  }

  capabilities {
    name = "EnableServerless"
  }

  geo_location {
    location          = var.rg_location
    failover_priority = 0
  }

  # Add public network access configuration
  public_network_access_enabled = true

  # Add IP rules if needed
  ip_range_filter = "0.0.0.0" # Be careful with this in production!

  # Add this to ensure proper key management
  key_vault_key_id = null # Remove any key vault references for now

  depends_on = [
    azurerm_resource_group.rg,
    azurerm_private_dns_zone.privatedns_aks,
    azurerm_kubernetes_cluster.aks_back
  ]

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_cosmosdb_sql_database" "sql_database" {
  name                = var.database_name
  resource_group_name = azurerm_cosmosdb_account.db_account.resource_group_name
  account_name        = azurerm_cosmosdb_account.db_account.name

  # Remove throughput for serverless mode
  # throughput          = 400

  depends_on = [azurerm_cosmosdb_account.db_account]
}

resource "azurerm_cosmosdb_sql_container" "sql_container" {
  name                  = var.sql_container_name
  resource_group_name   = azurerm_cosmosdb_account.db_account.resource_group_name
  account_name          = azurerm_cosmosdb_account.db_account.name
  database_name         = azurerm_cosmosdb_sql_database.sql_database.name
  partition_key_paths   = ["/definition/id"]
  partition_key_version = 1

  # Remove throughput for serverless mode
  # throughput          = 400

  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    included_path {
      path = "/included/?"
    }

    excluded_path {
      path = "/excluded/?"
    }
  }

  unique_key {
    paths = ["/definition/idlong", "/definition/idshort"]
  }

  depends_on = [
    azurerm_cosmosdb_sql_database.sql_database
  ]
}


# Private Endpoint for Cosmos DB 

resource "azurerm_private_endpoint" "cosmosdb_private_endpoint" {
  name                = "${var.db_account_name}-private-endpoint"
  location            = var.rg_location
  resource_group_name = var.rg_name
  subnet_id           = azurerm_subnet.private_endpoints_subnet.id
  private_service_connection {
    name                           = "cosmosdb-privatelink"
    private_connection_resource_id = azurerm_cosmosdb_account.db_account.id
    subresource_names              = ["Sql"]
    is_manual_connection           = false
  }

  depends_on = [
    azurerm_cosmosdb_account.db_account,
    azurerm_subnet.private_endpoints_subnet
  ]
}

# Private DNS A Record for Cosmos DB

resource "azurerm_private_dns_a_record" "cosmosdb_private_dns_a_record" {
  name                = "cosmosdb-private-dns-a-record"
  zone_name           = azurerm_private_dns_zone.privatedns_aks.name
  resource_group_name = var.rg_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.cosmosdb_private_endpoint.private_service_connection[0].private_ip_address]
  depends_on = [
    azurerm_private_endpoint.cosmosdb_private_endpoint
  ]
}


######################## Key Vault ########################

resource "azurerm_key_vault" "key_vault" {
  name                = "amoniac-key-vault"
  location            = var.rg_location
  resource_group_name = var.rg_name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

data "azurerm_client_config" "current" {}



################## User Assigned Identity  ##################

resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  name                = "amoniac-user-assigned-identity"
  location            = var.rg_location
  resource_group_name = var.rg_name
  depends_on = [
    azurerm_resource_group.rg
  ]
}

# Assigning the role of DocumentDB Account Contributor to the User Assigned Identity

resource "azurerm_role_assignment" "cosmosdb_account_contributor" {
  scope                = azurerm_cosmosdb_account.db_account.id
  role_definition_name = "DocumentDB Account Contributor"
  principal_id         = azurerm_user_assigned_identity.user_assigned_identity.principal_id
  depends_on = [
    azurerm_cosmosdb_account.db_account,
    azurerm_user_assigned_identity.user_assigned_identity
  ]
}


/*
# Assigning the role of Cosmos DB Account Contributor to the User Assigned Identity
//resource "azurerm_role_assignment" "cosmosdb_account_contributor" {
//  scope                = azurerm_cosmosdb_account.db_account.id
//  role_definition_name = "Cosmos DB Account Contributor"
//  principal_id         = azurerm_user_assigned_identity.user_assigned_identity.principal_id
//  depends_on = [
//    azurerm_cosmosdb_account.db_account,
//    azurerm_user_assigned_identity.user_assigned_identity
//  ]
//}

# Assigning the User Assigned Identity to Cosmos DB

#resource "azurerm_cosmosdb_sql_role_assignment" "cosmosdb_sql_role_assignment" {
#  resource_group_name = var.rg_name
#  account_name        = azurerm_cosmosdb_account.db_account.name
#  scope               = azurerm_cosmosdb_account.db_account.id
#  principal_id        = azurerm_user_assigned_identity.user_assigned_identity.principal_id
#  role_definition_id  = "00000000-0000-0000-0000-000000000001"
#}
*/





