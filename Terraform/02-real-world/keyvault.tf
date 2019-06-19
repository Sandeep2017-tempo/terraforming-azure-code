resource "azurerm_resource_group" "kv" {
  name     = "terraforming-azure-keyvault-rg"
  location = "${var.location}"

  tags = "${local.tags}"
}

resource "azurerm_key_vault" "kv" {
  name                = "tfkeyvault20190619"
  location            = "${azurerm_resource_group.kv.location}"
  resource_group_name = "${azurerm_resource_group.kv.name}"
  tenant_id           = "${var.tenantId}"

  sku {
    name = "standard"
  }

  access_policy {
    tenant_id = "${var.tenantId}"
    object_id = "${var.kvDefaultUserObjectId}"

    secret_permissions = ["list", "get", "set", "delete"]
  }

  tags = "${local.tags}"
}

resource "azurerm_key_vault_secret" "kv_s1" {
  name         = "secret-sauce"
  value        = "szechuan"
  key_vault_id = "${azurerm_key_vault.kv.id}"
}

resource "azurerm_key_vault_secret" "kv_s2" {
  name         = "private-key"
  value        = "${tls_private_key.demo.private_key_pem}"
  key_vault_id = "${azurerm_key_vault.kv.id}"
}

# Terraform figures out the dependency graph by itself
