resource "azurerm_role_assignment" "func_mi_assignment" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Reader"
  principal_id         = azurerm_linux_function_app.naming_func.identity[0].principal_id
}