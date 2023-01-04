resource "azurerm_resource_group" "rg" {
  location = "westeurope"
  name     = "{resource-group-name}"
  tags = {
    owner       = "me"
    environment = "test"
  }
}