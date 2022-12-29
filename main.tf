resource "azurerm_resource_group" "this" {
  name     = "${var.prefix}-resource-group"
  location = var.location
}

resource "random_string" "this" {
  length  = 32
  lower   = true
  numeric = true
  special = false
  upper   = true
}

resource "random_password" "this" {
  length           = 32
  lower            = true
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  numeric          = true
  override_special = "_" # Make compatible with bash and PostgreSQL URL
  special          = true
  upper            = true
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                   = "${var.prefix}-postgresql-flexible-server"
  resource_group_name    = azurerm_resource_group.this.name
  location               = azurerm_resource_group.this.location
  administrator_login    = random_string.this.result
  administrator_password = random_password.this.result
  sku_name               = "B_Standard_B1ms"
  storage_mb             = 32768
  version                = "14"
  zone                   = "1"
}

resource "azurerm_postgresql_flexible_server_database" "prod" {
  name      = "prod"
  server_id = azurerm_postgresql_flexible_server.this.id
}

resource "azurerm_postgresql_flexible_server_database" "test" {
  name      = "test"
  server_id = azurerm_postgresql_flexible_server.this.id
}

# Equivalent to "Allow access to Azure services"
# TODO: Replace this with a virtual network
resource "azurerm_postgresql_flexible_server_firewall_rule" "this" {
  name             = "${var.prefix}-postgresql-flexible-server-firewall-rule"
  server_id        = azurerm_postgresql_flexible_server.this.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_container_registry" "this" {
  name                = replace("${var.prefix}-container-registry", "-", "")
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = "Standard"
  admin_enabled       = true
}

# TODO: Replace this with k8s
resource "azurerm_container_group" "this" {
  name                = "${var.prefix}-container-instance"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  os_type             = "Linux"
  dns_name_label      = var.prefix
  ip_address_type     = "Public"

  # This dummy container is placed here as a required placeholder. The true
  # container is pushed from a CI/CD workflow in the peanubudget-backend
  # repository
  container {
    name   = "hello-world"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld"
    cpu    = "1"
    memory = "1"

    ports {
      port     = 443
      protocol = "TCP"
    }
  }
}
