resource "azurerm_storage_account" "storage_acct" {
  name                = "{storage-account-name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"

  min_tls_version           = "TLS1_2"
  enable_https_traffic_only = true

  tags = {
    owner       = "me"
    environment = "test"
  }
}