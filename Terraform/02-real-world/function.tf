// Resource group for the Function App
resource "azurerm_resource_group" "demo" {
  name     = "terraforming-azure-function-app-rg"
  location = "${var.location}"

  tags = "${local.tags}"
}

// Storage account (needed for the Function App to work)
resource "azurerm_storage_account" "demo" {
  name                     = "ensoterraformingazure"
  resource_group_name      = "${azurerm_resource_group.demo.name}"
  location                 = "${azurerm_resource_group.demo.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS" # Local Redundant Storage

  tags = "${local.tags}"
}

// [Consumption] Service Plan (needed for the Function App to work)
resource "azurerm_app_service_plan" "demo" {
  name                = "enso-terraforming-azure-service-plan"
  location            = "${azurerm_resource_group.demo.location}"
  resource_group_name = "${azurerm_resource_group.demo.name}"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic" # Makes it use the consumption plan
    size = "Y1"      # Magic value that relates to "Dynamic"
  }

  tags = "${local.tags}"
}

// Application Insihgts
resource "azurerm_application_insights" "demo" {
  name                = "enso-terraaforming-azure-functions"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.demo.name}"
  application_type    = "Web"

  tags = "${local.tags}"
}

// The function app itself
resource "azurerm_function_app" "demo" {
  name                      = "enso-terraforming-azure-functions"
  location                  = "${azurerm_resource_group.demo.location}"
  resource_group_name       = "${azurerm_resource_group.demo.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.demo.id}"
  storage_connection_string = "${azurerm_storage_account.demo.primary_connection_string}"

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = "${azurerm_application_insights.demo.instrumentation_key}"
    PublicKey                      = "${base64encode(tls_private_key.demo.public_key_pem)}"
    ChaosMonkeys                   = 42
  }

  tags = "${local.tags}"
}
