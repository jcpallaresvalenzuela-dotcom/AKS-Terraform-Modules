output "resource_group_name" {
  value = module.rg.name
}

output "aks_name" {
  value = module.aks.name
}

output "kubeconfig_raw" {
  description = "Kubeconfig en texto (sensitivo)."
  value       = module.aks.kubeconfig_raw
  sensitive   = true
}
