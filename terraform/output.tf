output "sas_connection_string" {
  sensitive = true
  value     = azurerm_storage_account.storage_acct.primary_connection_string
}