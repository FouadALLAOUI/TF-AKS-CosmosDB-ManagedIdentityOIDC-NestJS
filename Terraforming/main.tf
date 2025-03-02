# Create resource group
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.rg_location
}


# Networking module
module "networking" {
  source                = "./modules/networking"
  rg_name               = azurerm_resource_group.rg.name
  rg_location           = azurerm_resource_group.rg.location
  vnet_name             = var.backend_vnet_name
  vnet_address_space    = var.backend_vnet_address_space
  environment           = var.environment
  private_dns_zone_name = var.private_dns_zone_name
}

# Key Vault module
module "keyvault" {
  source         = "./modules/keyvault"
  rg_name        = azurerm_resource_group.rg.name
  rg_location    = azurerm_resource_group.rg.location
  environment    = var.environment
  subnet_id      = module.networking.private_endpoints_subnet_id
  key_vault_name = var.key_vault_name
  depends_on     = [module.networking]
}

# Managed Identity module
module "managed_identity" {
  source        = "./modules/managed_identity"
  rg_name       = azurerm_resource_group.rg.name
  rg_location   = azurerm_resource_group.rg.location
  identity_name = "${var.environment}-managed-identity"
  environment   = var.environment
  key_vault_id  = module.keyvault.key_vault_id
  tenant_id     = module.keyvault.tenant_id
  //cosmos_db_id  = module.cosmos_db.account_id
  depends_on = [module.keyvault] //, module.cosmos_db]
}
















/*
# AKS module
module "aks" {
  source              = "./modules/aks"
  rg_name             = azurerm_resource_group.rg.name
  rg_location         = azurerm_resource_group.rg.location
  aks_cluster_name    = var.aks_cluster_name
  kubernetes_version  = var.kubernetes_version
  aks_subnet_id       = module.networking.aks_subnet_id
  private_dns_zone_id = module.networking.private_dns_zone_id
  environment         = var.environment
  depends_on          = [module.networking]
}

# Cosmos DB module
module "cosmos_db" {
  source              = "./modules/cosmos_db"
  rg_name             = azurerm_resource_group.rg.name
  rg_location         = azurerm_resource_group.rg.location
  db_account_name     = var.db_account_name
  database_name       = var.database_name
  sql_container_name  = var.sql_container_name
  subnet_id           = module.networking.private_endpoints_subnet_id
  private_dns_zone_id = module.networking.private_dns_zone_id
  depends_on          = [module.networking]
}

# APIM module
module "apim" {
  source      = "./modules/apim"
  rg_name     = azurerm_resource_group.rg.name
  rg_location = azurerm_resource_group.rg.location
  subnet_id   = module.networking.apim_subnet_id
  depends_on  = [module.networking]
}

# Jump Server module (commented out by default)
/*
module "jumpserver" {
  source              = "./modules/jumpserver"
  rg_name             = azurerm_resource_group.rg.name
  rg_location         = azurerm_resource_group.rg.location
  subnet_id           = module.networking.vm_subnet_id
  depends_on          = [module.networking]
}
*/





