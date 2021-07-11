output "resource_group_name" {
  value = azurerm_resource_group.tf_resource_group.name
}

output "resource_group_location" {
  value = azurerm_resource_group.tf_resource_group.location
}

output "az_storage_acc" {
  value = azurerm_storage_account.tf_store_acc.name
}

output "az_app_serv_plan" {
  value = azurerm_app_service_plan.tf_app_serv_plan.name
}

output "az_func_app" {
  value = azurerm_function_app.tf_func_app.name
}