output "resource_group_name" {
  value       = azurerm_resource_group.this.name
  description = "The resource group's name"
}

output "database_username" {
  value       = azurerm_postgresql_flexible_server.this.administrator_login
  description = "The database's username"
}

output "database_password" {
  value       = azurerm_postgresql_flexible_server.this.administrator_password
  description = "The database's password"
  sensitive   = true
}

output "database_fqdn" {
  value       = azurerm_postgresql_flexible_server.this.fqdn
  description = "The database's FQND"
}

output "container_registry_username" {
  value       = azurerm_container_registry.this.admin_username
  description = "The container registry's username"
}

output "container_registry_password" {
  value       = azurerm_container_registry.this.admin_password
  description = "The container registry's password"
  sensitive   = true
}

output "container_registry_fqdn" {
  value       = azurerm_container_registry.this.login_server
  description = "The container registry's FQND"
}

output "app_fqdn" {
  value       = azurerm_container_group.this.fqdn
  description = "The app's FQDN"
}
