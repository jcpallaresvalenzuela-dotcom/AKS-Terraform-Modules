output "resource_group_name" {
  description = "Nombre del Resource Group creado."
  value       = module.resource_group.name
  sensitive   = true
}

output "resource_group_location" {
  description = "Ubicación del Resource Group."
  value       = module.resource_group.location
  sensitive = true
}

output "resource_group_id" {
  description = "ID del Resource Group creado."
  value       = module.resource_group.id
  sensitive   = true
}
