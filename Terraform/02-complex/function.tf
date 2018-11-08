// Resource group for the Function App
resource "azurerm_resource_group" "demofapp" {
  name     = "terraforming-azure-function-app-rg"
  location = "${var.location}"

  tags = {
    environment = "${var.env}"
  }
}

// Storage account (needed for the Function App to work)
resource "azurerm_storage_account" "demo" {
  name                     = "ensoterraformingazure"
  resource_group_name      = "${azurerm_resource_group.demofapp.name}"
  location                 = "${azurerm_resource_group.demofapp.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "${var.env}"
  }
}

// [Consumption] Service Plan (needed for the Function App to work)
resource "azurerm_app_service_plan" "demo" {
  name                = "enso-terraforming-azure-service-plan"
  location            = "${azurerm_resource_group.demofapp.location}"
  resource_group_name = "${azurerm_resource_group.demofapp.name}"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic" // consumption
    size = "Y1"
  }

  tags = {
    environment = "${var.env}"
  }
}

// Application Insihgts
resource "azurerm_application_insights" "demo" {
  name                = "enso-terraaforming-azure-functions"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.demofapp.name}"
  application_type    = "Web"

  tags = {
    environment = "${var.env}"
  }
}

// The function app itself
resource "azurerm_function_app" "demo" {
  name                      = "enso-terraforming-azure-functions"
  location                  = "${azurerm_resource_group.demofapp.location}"
  resource_group_name       = "${azurerm_resource_group.demofapp.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.demo.id}"
  storage_connection_string = "${azurerm_storage_account.demo.primary_connection_string}"

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY        = "${azurerm_application_insights.demo.instrumentation_key}"
    GreetingQueueListenerConnectionString = "${azurerm_servicebus_queue_authorization_rule.listenerRule.primary_connection_string}"
    GreetingQueueSenderConnectionString   = "${azurerm_servicebus_queue_authorization_rule.senderRule.primary_connection_string}"
    PrivateKey                            = "${base64encode(tls_private_key.demo.private_key_pem)}"
    SuperSecretPassword                   = "${random_string.password.result}"
  }

  tags = {
    environment = "${var.env}"
  }
}

