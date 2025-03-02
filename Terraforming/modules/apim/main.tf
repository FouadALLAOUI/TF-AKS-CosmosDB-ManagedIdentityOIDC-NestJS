# Public IP for APIM
resource "azurerm_public_ip" "apim_public_ip" {
  name                = "apim-public-ip"
  resource_group_name = var.rg_name
  location            = var.rg_location
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "apim-${lower(replace(var.rg_name, "_", "-"))}"

  tags = {
    environment = var.environment
    purpose     = "APIM"
  }
}

# Network Security Group for APIM
resource "azurerm_network_security_group" "apim_nsg" {
  name                = "apim-nsg"
  location            = var.rg_location
  resource_group_name = var.rg_name

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

# API Management Instance
resource "azurerm_api_management" "apim" {
  name                = var.apim_name
  location            = var.rg_location
  resource_group_name = var.rg_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email

  sku_name = var.sku_name

  virtual_network_type = "External"

  virtual_network_configuration {
    subnet_id = var.subnet_id
  }

  public_ip_address_id = azurerm_public_ip.apim_public_ip.id

  protocols {
    enable_http2 = true
  }

  security {
    enable_backend_ssl30 = false
  }

  tags = {
    Environment = var.environment
  }
}

# Log Analytics Workspace for APIM
resource "azurerm_log_analytics_workspace" "apim_logs" {
  name                = "${var.apim_name}-logs"
  location            = var.rg_location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
}

# Diagnostic Settings for APIM
resource "azurerm_monitor_diagnostic_setting" "apim_diagnostics" {
  name                       = "apim-diagnostics"
  target_resource_id         = azurerm_api_management.apim.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.apim_logs.id

  enabled_log {
    category = "GatewayLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
} 