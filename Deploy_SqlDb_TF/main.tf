provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "demo_resource_group" {
  name     = "${var.prefix}-resources"
  location = var.location
}

resource "azurerm_sql_server" "demo_sql_srv" {
  name                         = "${var.prefix}-sqlsvr"
  resource_group_name          = azurerm_resource_group.demo_resource_group.name
  location                     = azurerm_resource_group.demo_resource_group.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_sql_database" "demo_sql_db" {
  name                             = "${var.prefix}-db"
  resource_group_name              = azurerm_resource_group.demo_resource_group.name
  location                         = azurerm_resource_group.demo_resource_group.location
  server_name                      = azurerm_sql_server.demo_sql_srv.name
  edition                          = "Basic"
  collation                        = "SQL_Latin1_General_CP1_CI_AS"
  create_mode                      = "Default"
  requested_service_objective_name = "Basic"
}

resource "azurerm_sql_firewall_rule" "demo_sql_firewall_rule" {
  name                = "allow-azure-services"
  resource_group_name = azurerm_resource_group.demo_resource_group.name
  server_name         = azurerm_sql_server.demo_sql_srv.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
