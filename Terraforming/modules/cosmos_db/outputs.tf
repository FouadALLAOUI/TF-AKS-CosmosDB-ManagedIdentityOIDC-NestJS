output "account_id" {
  description = "The ID of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.db.id
}

output "endpoint" {
  description = "The endpoint of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.db.endpoint
}

output "primary_key" {
  description = "The primary key of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.db.primary_key
  sensitive   = true
}

output "connection_strings" {
  description = "The connection strings of the Cosmos DB account"
  value       = azurerm_cosmosdb_account.db.connection_strings
  sensitive   = true
}

output "private_endpoint_ip" {
  description = "The private IP of the Cosmos DB endpoint"
  value       = azurerm_private_endpoint.cosmos_endpoint.private_service_connection[0].private_ip_address
}

output "database_id" {
  description = "The ID of the Cosmos DB SQL database"
  value       = azurerm_cosmosdb_sql_database.db.id
}

output "container_id" {
  description = "The ID of the Cosmos DB SQL container"
  value       = azurerm_cosmosdb_sql_container.container.id
} 