# Optional, but tells Terraform to use the Azure Resource Manager provider
provider "azurerm" {}

# Variables are strings by default
variable "location" {
  default = "West Europe"
}
variable "storageAccountName" {}
variable "accountType" {}
variable "kind" {}
variable "accessTier" {}
variable "supportHttpsTrafficOnly" {}

# Terraform can create the resource group at the same time as the resources 
resource "azurerm_resource_group" "rg" {
  name     = "ndc-terraform-storage-rg"
  location = "${var.location}"

  tags = {
    tool        = "Terraform"
    environment = "test"
    demo        = 2
  }
}

# This defines a storage account and gives it the alias "sa"
resource "azurerm_storage_account" "sa" {
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  name                      = "${var.storageAccountName}"
  location                  = "${var.location}"
  account_replication_type  = "${var.accountType}"
  account_kind              = "${var.kind}"
  account_tier              = "Standard"
  access_tier               = "${var.accessTier}"
  enable_https_traffic_only = "${var.supportHttpsTrafficOnly}"

  tags = {
    tool        = "Terraform"
    environment = "test"
    demo        = 2
  }
}

# This output is marked as sensitive
output "storageAccountKey" {
  value     = "${azurerm_storage_account.sa.primary_access_key}"
  sensitive = true
}
