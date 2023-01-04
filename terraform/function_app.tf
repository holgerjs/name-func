resource "azurerm_service_plan" "consumption_plan" {
  name                = "plan-nfn-tst-we-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "naming_func" {
  name                       = "func-nfn-tst-we-001"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  service_plan_id            = azurerm_service_plan.consumption_plan.id
  storage_account_name       = azurerm_storage_account.storage_acct.name
  storage_account_access_key = azurerm_storage_account.storage_acct.primary_access_key

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    ENABLE_ORYX_BUILD              = true
    SCM_DO_BUILD_DURING_DEPLOYMENT = true
    AzureWebJobsFeatureFlags       = "EnableWorkerIndexing"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.func_app_insights.instrumentation_key
  }

  site_config {
    application_stack {
      python_version = "3.9"
    }
  }
}