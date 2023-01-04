resource "azurerm_application_insights" "func_app_insights" {
  name                = "ains-nfn-tst-we-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "other"
}