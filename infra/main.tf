provider "azurerm" {
  features {}
}

variable "docker_image" {
  type        = string
  description = "docker image to deploy to app service"
}

resource "azurerm_resource_group" "vehicleservice_resource_group" {
  name     = "vehicleservice_resource_group"
  location = "West US"
}

resource "azurerm_app_service_plan" "vehicleservice_app_service_plan" {
  name                = "vehicleservice-appservice-plan"
  location            = azurerm_resource_group.vehicleservice_resource_group.location
  resource_group_name = azurerm_resource_group.vehicleservice_resource_group.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "random_uuid" "service_id" {
}

resource "azurerm_app_service" "vehicleservice_app_service" {
  name                = "vehicleservice-${random_uuid.service_id.result}"
  location            = azurerm_resource_group.vehicleservice_resource_group.location
  resource_group_name = azurerm_resource_group.vehicleservice_resource_group.name
  app_service_plan_id = azurerm_app_service_plan.vehicleservice_app_service_plan.id

  site_config {
    app_command_line = "docker build -t ${var.docker_image}:latest ../VehicleService"
  }
}

resource "azurerm_cosmosdb_account" "vehicleservice_db" {
  name                = "vehicleservice-cosmosdb-account-${random_uuid.service_id.result}"
  location            = azurerm_resource_group.vehicleservice_resource_group.location
  resource_group_name = azurerm_resource_group.vehicleservice_resource_group.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = "West US"
    failover_priority = 0
  }
}

output "cosmosdb_connection_string" {
  sensitive = true
  value     = azurerm_cosmosdb_account.vehicleservice_db.connection_strings[0]
}
