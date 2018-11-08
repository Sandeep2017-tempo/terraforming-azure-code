// Resource group
resource "azurerm_resource_group" "demo" {
  name     = "terraforming-azure-servicebus-rg"
  location = "${var.location}"

  tags = {
    environment = "${var.env}"
  }
}

// ServiceBus Namespace
resource "azurerm_servicebus_namespace" "demo" {
  name                = "${var.servicebus_name}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.demo.name}"
  sku                 = "basic"

  tags = {
    environment = "${var.env}"
  }
}

// ServiceBus Queue (greetingQueue)
resource "azurerm_servicebus_queue" "demo" {
  name                = "greetingQueue"
  resource_group_name = "${azurerm_resource_group.demo.name}"
  namespace_name      = "${azurerm_servicebus_namespace.demo.name}"

  enable_partitioning = true
}

// Create authorization rule for listening on greetingQueue
resource "azurerm_servicebus_queue_authorization_rule" "listenerRule" {
  name                = "AzureFunctionListener"
  namespace_name      = "${azurerm_servicebus_namespace.demo.name}"
  queue_name          = "${azurerm_servicebus_queue.demo.name}"
  resource_group_name = "${azurerm_resource_group.demo.name}"

  send   = false
  listen = true
}

// Create authorization rule for sending to greetingQueue
resource "azurerm_servicebus_queue_authorization_rule" "senderRule" {
  name                = "AzureFunctionReader"
  namespace_name      = "${azurerm_servicebus_namespace.demo.name}"
  queue_name          = "${azurerm_servicebus_queue.demo.name}"
  resource_group_name = "${azurerm_resource_group.demo.name}"

  send   = true
  listen = false
}
