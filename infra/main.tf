provider "azurerm" {
  features {}
  subscription_id = "<YOUR SUBSCRIPTION ID>"
  client_id       = "<YOUR CLIENT ID>"
  client_secret   = "<YOUR CLIENT SECRET>"
  tenant_id       = "<YOUR TENANT ID>"
}


resource "azurerm_resource_group" "vehicleservice_resource_group" {
  name     = "vehicleservice_resource_group"
  location = "West US"
}

resource "azurerm_app_service_plan" "vehicleservice_app_service_plan" {
  name                = "vehicleservice-appservice-plan"
  location            = azurerm_resource_group.vehicleservice_resource_group
  resource_group_name = azurerm_resource_group.vehicleservice_resource_group.name
  kind                = "Linux"

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "vehicleservice_app_service" {
  name                = "vehicleservice"
  location            = azurerm_resource_group.vehicleservice_resource_group
  resource_group_name = azurerm_resource_group.vehicleservice_resource_group.name
  app_service_plan_id = azurerm_resource_group.vehicleservice_resource_group.id

  site_config {
    linux_fx_version = "DOCKER|<DOCKER_IMAGE_NAME>"
  }
}

resource "azurerm_cosmosdb_account" "vehicleservice_db" {
  name                = "vehicleservice-cosmosdb-account"
  location            = azurerm_resource_group.vehicleservice_resource_group
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
  value = azurerm_cosmosdb_account.vehicleservice_db.connection_strings[0]
}
