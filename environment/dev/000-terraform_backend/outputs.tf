output "resource_group_name" {
  description = "Nombre del Resource Group creado para el backend de Terraform."
  value = module.terraform_backend.resource_group_name
}

output "storage_account_name" {
  description = "Nombre del Storage Account creado para el backend de Terraform."
  value = module.terraform_backend.storage_account_name
}

output "container_name" {
  description = "Nombre del container creado para los archivos de estado."
  value = module.terraform_backend.container_name
}

output "storage_account_key" {
  description = "Clave de acceso del Storage Account (sensible)."
  value     = module.terraform_backend.storage_account_key
  sensitive = true
}

output "backend_config" {
  description = "Configuración del backend para usar en los módulos de Terraform."
  value = module.terraform_backend.backend_config
}
