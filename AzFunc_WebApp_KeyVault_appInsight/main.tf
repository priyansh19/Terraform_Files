resource "azurerm_resource_group" "tf_resource_group" {
  name     = "${var.prefix}-res-grp"
  location = var.location
}

resource "azurerm_storage_account" "tf_store_acc" {
  name                     = "terraformdatastracc"
  resource_group_name      = azurerm_resource_group.tf_resource_group.name
  location                 = azurerm_resource_group.tf_resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_sql_server" "tf_sql_srv" {
  name                         = "${var.prefix}-sqlsvr"
  resource_group_name          = azurerm_resource_group.tf_resource_group.name
  location                     = azurerm_resource_group.tf_resource_group.location
  version                      = "12.0"
  administrator_login          = "demouser"
  administrator_login_password = "admin@1234"
}

resource "azurerm_sql_database" "tf_sql_db" {
  name                             = "${var.prefix}-db"
  resource_group_name              = azurerm_resource_group.tf_resource_group.name
  location                         = azurerm_resource_group.tf_resource_group.location
  server_name                      = azurerm_sql_server.tf_sql_srv.name
  edition                          = "Basic"
  collation                        = "SQL_Latin1_General_CP1_CI_AS"
  create_mode                      = "Default"
  requested_service_objective_name = "Basic"
}

resource "azurerm_sql_firewall_rule" "tf_sql_firewall_rule" {
  name                = "allow-azure-services"
  resource_group_name = azurerm_resource_group.tf_resource_group.name
  server_name         = azurerm_sql_server.tf_sql_srv.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_app_service_plan" "tf_app_serv_plan" {
  name                = "${var.prefix}-service-plan"
  location            = azurerm_resource_group.tf_resource_group.location
  resource_group_name = azurerm_resource_group.tf_resource_group.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
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

resource "azurerm_application_insights" "tf_app_insight" {
  name                = "tf-test-appinsights"
  location            = azurerm_resource_group.tf_resource_group.location
  resource_group_name = azurerm_resource_group.tf_resource_group.name
  application_type    = "web"
}