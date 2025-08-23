output "resource_group_name" {
  description = "Nombre del Resource Group creado para el backend de Terraform."
  value = azurerm_resource_group.terraform_state.name
}

output "storage_account_name" {
  description = "Nombre del Storage Account creado para el backend de Terraform."
  value = azurerm_storage_account.terraform_state.name
}

output "container_name" {
  description = "Nombre del container creado para los archivos de estado."
  value = azurerm_storage_container.terraform_state.name
}

output "storage_account_key" {
  description = "Clave de acceso del Storage Account (sensible)."
  value     = azurerm_storage_account.terraform_state.primary_access_key
  sensitive = true
}

output "backend_config" {
  description = "Configuración del backend para usar en los módulos de Terraform."
  value = {
    resource_group_name  = azurerm_resource_group.terraform_state.name
    storage_account_name = azurerm_storage_account.terraform_state.name
    container_name       = azurerm_storage_container.terraform_state.name
  }
}
