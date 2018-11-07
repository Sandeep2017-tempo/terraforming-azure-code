provider "azurerm" {}

variable "location" {}
variable "storageAccountName" {}
variable "accountType" {}
variable "kind" {}
variable "accessTier" {}
variable "supportHttpsTrafficOnly" {}

resource "azurerm_resource_group" "rg" {
  // This is not done by ARM template, but by the deploy script
  name     = "terraform-storage-rg"
  location = "${var.location}"

  tags {
    environment = "test"
  }
}

resource "azurerm_storage_account" "sa" {
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  name                      = "${var.storageAccountName}"
  location                  = "${var.location}"
  account_replication_type  = "${var.accountType}"
  account_kind              = "${var.kind}"
  account_tier              = "Standard"
  access_tier               = "${var.accessTier}"
  enable_https_traffic_only = "${var.supportHttpsTrafficOnly}"

  tags {
    environment = "test"
  }
}

output "storageAccountKey" {
  value     = "${azurerm_storage_account.sa.primary_access_key}"
  sensitive = true
}
