output "sql_server_fqdn" {
  value = azurerm_sql_server.demo_sql_srv.fully_qualified_domain_name
}

output "database_name" {
  value = azurerm_sql_database.demo_sql_db.name
}
