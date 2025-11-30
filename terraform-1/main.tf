terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
} 

# Create a Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = "southeastasia"
}

# Create an App Service Plan (F1 Free Tier)
resource "azurerm_service_plan" "appserviceplan" {
  name                = "free-appservice-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location           = azurerm_resource_group.rg.location
  os_type            = "Linux"
  sku_name           = "F1"
}

# Create PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = var.postgres_server_name
  resource_group_name    = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  version               = "13"
  administrator_login    = var.postgres_admin_login
  administrator_password = var.postgres_admin_password
  storage_mb            = 32768
  sku_name              = "B_Standard_B1ms"
  zone                  = "1"

  depends_on = [azurerm_resource_group.rg]
}

# Create PostgreSQL Database
resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = var.postgres_database_name
  server_id = azurerm_postgresql_flexible_server.postgres.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

# Allow Azure services to access PostgreSQL
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure" {
  name             = "allow-azure-services"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Create an App Service with a Docker Container
resource "azurerm_linux_web_app" "webapp" {
  name                = var.app_name
  resource_group_name = azurerm_resource_group.rg.name
  location           = azurerm_resource_group.rg.location
  service_plan_id    = azurerm_service_plan.appserviceplan.id

  site_config {
    application_stack {
      docker_image_name = "dgpthinh/quotes-api:v2" 
    }
    always_on = false
  }

  app_settings = {
    "DATABASE_URL" = "postgresql://${var.postgres_admin_login}:${var.postgres_admin_password}@${azurerm_postgresql_flexible_server.postgres.fqdn}:5432/${var.postgres_database_name}?sslmode=require"
    "PORT"         = "3000"
    "WEBSITES_PORT" = "3000"
  }

  depends_on = [azurerm_service_plan.appserviceplan, azurerm_postgresql_flexible_server.postgres]  

}

