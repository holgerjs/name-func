resource "azurerm_application_insights" "func_app_insights" {
  name                = "{app-insights-name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "other"
}