# Random integer for unique naming
resource "random_integer" "ri" {
  min = 10
  max = 100
}

# Cosmos DB Account
resource "azurerm_cosmosdb_account" "db" {
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

  public_network_access_enabled = true
  ip_range_filter               = var.ip_range_filter

  tags = {
    Environment = var.environment
  }
}

# SQL Database
resource "azurerm_cosmosdb_sql_database" "db" {
  name                = var.database_name
  resource_group_name = var.rg_name
  account_name        = azurerm_cosmosdb_account.db.name
}

# SQL Container
resource "azurerm_cosmosdb_sql_container" "container" {
  name                = var.sql_container_name
  resource_group_name = var.rg_name
  account_name        = azurerm_cosmosdb_account.db.name
  database_name       = azurerm_cosmosdb_sql_database.db.name
  partition_key_path  = "/definition/id"

  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    excluded_path {
      path = "/excluded/?"
    }
  }

  unique_key {
    paths = ["/definition/idlong", "/definition/idshort"]
  }
}

# Private Endpoint
resource "azurerm_private_endpoint" "cosmos_endpoint" {
  name                = "${var.db_account_name}-endpoint"
  location            = var.rg_location
  resource_group_name = var.rg_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "cosmos-privatelink"
    private_connection_resource_id = azurerm_cosmosdb_account.db.id
    subresource_names              = ["Sql"]
    is_manual_connection           = false
  }
}

# Private DNS A Record
resource "azurerm_private_dns_a_record" "cosmos_dns" {
  name                = "cosmos-private-endpoint"
  zone_name           = var.private_dns_zone_name
  resource_group_name = var.rg_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.cosmos_endpoint.private_service_connection[0].private_ip_address]
} 