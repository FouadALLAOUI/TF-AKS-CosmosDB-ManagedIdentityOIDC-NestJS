# Backend Virtual Network
resource "azurerm_virtual_network" "vnet_backend" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = var.rg_location
  resource_group_name = var.rg_name
}

# AKS Subnet
resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet_backend.name
  address_prefixes     = [var.aks_subnet_cidr]
}

# Private Endpoints Subnet
resource "azurerm_subnet" "private_endpoints_subnet" {
  name                 = "private-endpoints-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet_backend.name
  address_prefixes     = [var.endpoints_subnet_cidr]
}

# APIM Subnet
resource "azurerm_subnet" "apim_subnet" {
  name                 = "apim-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet_backend.name
  address_prefixes     = [var.apim_subnet_cidr]
}

# Private DNS Zone
resource "azurerm_private_dns_zone" "private_dns" {
  name                = var.private_dns_zone_name
  resource_group_name = var.rg_name
}

# DNS Zone Link
resource "azurerm_private_dns_zone_virtual_network_link" "dns_zone_link" {
  name                  = "dns-zone-link"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet_backend.id
}



# frontend virtual network
resource "azurerm_virtual_network" "vnet_frontend" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = var.rg_location
  resource_group_name = var.rg_name
  depends_on          = [azurerm_virtual_network.vnet_backend]
}

# frontend subnet
resource "azurerm_subnet" "frontend_subnet" {
  name                 = "frontend-subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet_frontend.name
  address_prefixes     = [var.frontend_subnet_address_space]
}

# Peering from backend to frontend
resource "azurerm_virtual_network_peering" "backend_to_frontend" {
  name                         = "backend-to-frontend"
  resource_group_name          = var.rg_name
  virtual_network_name         = azurerm_virtual_network.vnet_backend.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_frontend.id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

# Peering from frontend to backend
resource "azurerm_virtual_network_peering" "frontend_to_backend" {
  name                         = "frontend-to-backend"
  resource_group_name          = var.rg_name
  virtual_network_name         = azurerm_virtual_network.vnet_frontend.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_backend.id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}





