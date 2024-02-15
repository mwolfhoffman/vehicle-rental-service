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


resource "azurerm_service_plan" "vehicleservice_resource_group" {
  name                = "vehicleservice_resource_group"
  resource_group_name = azurerm_resource_group.vehicleservice_resource_group.name
  location            = azurerm_resource_group.vehicleservice_resource_group.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}


resource "azurerm_linux_web_app" "vehicleservice_app_service" {
  name                = "vehicleservice-appservice-plan"
  location            = azurerm_resource_group.vehicleservice_resource_group.location
  resource_group_name = azurerm_resource_group.vehicleservice_resource_group.name
  service_plan_id     = azurerm_service_plan.vehicleservice_resource_group.id

  site_config {
    always_on        = true
    app_command_line = <<-EOT
      /bin/bash -c '
        docker build -t ${var.docker_image}:latest ../VehicleService
        docker run -d -p 3000:80 ${var.docker_image}:latest
      '
    EOT
  }
}

resource "azurerm_cosmosdb_account" "vehicleservice_db" {
  name                = "vehicleservice-cosmos-db"
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

