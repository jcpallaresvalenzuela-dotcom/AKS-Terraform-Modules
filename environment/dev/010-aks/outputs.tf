output "resource_group_name" {
  description = "Nombre del Resource Group del AKS."
  value       = module.aks.resource_group_name
  sensitive   = true
}

output "aks_name" {
  description = "Nombre del cluster AKS."
  value       = module.aks.name
  sensitive   = true
}

output "kubeconfig_raw" {
  description = "Kubeconfig en texto (sensitivo)."
  value       = module.aks.kubeconfig_raw
  sensitive   = true
}

/* output "ingress_public_ip" {
  value = module.ingress_ip.public_ip
}

output "ingress_ip_resource_group" {
  value = module.ingress_ip.resource_group
} */