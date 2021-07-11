resource "azurerm_resource_group" "tf_resource_group" {
  name     = "${var.prefix}-res-grp"
  location = var.location
}

// for current tenant and sub to be picked up 
data "azurerm_client_config" "current" {} 

resource "azurerm_storage_account" "tf_store_acc" {
  name                     = "terraformdatastracc"
  resource_group_name      = azurerm_resource_group.tf_resource_group.name
  location                 = azurerm_resource_group.tf_resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "tf_app_serv_plan" {
  name                = "${var.prefix}-service-plan"
  location            = azurerm_resource_group.tf_resource_group.location
  resource_group_name = azurerm_resource_group.tf_resource_group.name
  kind                = "FunctionApp"

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "tf_app_serv" {
  name                = "${var.prefix}-app-service"
  location            = azurerm_resource_group.tf_resource_group.location
  resource_group_name = azurerm_resource_group.tf_resource_group.name
  app_service_plan_id = azurerm_app_service_plan.tf_app_serv_plan.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }
}

resource "azurerm_function_app" "tf_func_app" {
  name                       = "${var.prefix}-ais-tfdemo-function"
  location                   = azurerm_resource_group.tf_resource_group.location
  resource_group_name        = azurerm_resource_group.tf_resource_group.name
  app_service_plan_id        = azurerm_app_service_plan.tf_app_serv_plan.id
  storage_account_name       = azurerm_storage_account.tf_store_acc.name
  storage_account_access_key = azurerm_storage_account.tf_store_acc.primary_access_key
}

# resource "azurerm_key_vault" "tf_key_vault" {
#   name                       = "key-vault-pg-in-001"
#   location                   = azurerm_resource_group.tf_resource_group.location
#   resource_group_name        = azurerm_resource_group.tf_resource_group.name
#   tenant_id                  = data.azurerm_client_config.current.tenant_id
#   sku_name                   = "premium"
#   soft_delete_retention_days = 7

#   access_policy {
#     tenant_id = data.azurerm_client_config.current.tenant_id
#     object_id = data.azurerm_client_config.current.object_id

#     key_permissions = [
#       "create",
#       "get",
#       "list"
#     ]

#     secret_permissions = [
#       "set",
#       "get",
#       "delete",
#       "purge",
#       "recover",
#       "list"
#     ]
#   }
# }

# resource "azurerm_key_vault_secret" "test-secret-key" {
#   name         = "sql-connection-string"
#   value        = "testsamplestringtobeadded001"
#   key_vault_id = azurerm_key_vault.tf_key_vault.id
# }

resource "azurerm_application_insights" "tf_app_insight" {
  name                = "tf-test-appinsights"
  location            = azurerm_resource_group.tf_resource_group.location
  resource_group_name = azurerm_resource_group.tf_resource_group.name
  application_type    = "web"
}