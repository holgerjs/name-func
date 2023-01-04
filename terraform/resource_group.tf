resource "azurerm_resource_group" "rg" {
  location = "westeurope"
  name     = "rg-nfn-tst-we-001"
  tags = {
    owner       = "me"
    environment = "test"
  }
}