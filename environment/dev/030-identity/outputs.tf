output "identity_id" {
  description = "ID de la User Assigned Managed Identity."
  value       = module.identity.id
  sensitive   = true
}

output "identity_client_id" {
  description = "Client ID de la User Assigned Managed Identity."
  value       = module.identity.client_id
  sensitive   = true
}

output "identity_principal_id" {
  description = "Principal ID de la User Assigned Managed Identity."
  value       = module.identity.principal_id
  sensitive   = true
}

output "identity_name" {
  description = "Nombre de la User Assigned Managed Identity."
  value       = module.identity.name
  sensitive   = true
}
