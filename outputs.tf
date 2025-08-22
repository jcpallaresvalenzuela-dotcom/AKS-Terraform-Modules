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

output "ingress_public_ip" {
  value = module.ingress_ip.public_ip
}

output "ingress_ip_resource_group" {
  value = module.ingress_ip.resource_group
}