output "ingress_public_ip" {
  description = "IP pública asignada para el ingress."
  value       = module.ingress_ip.public_ip
}

output "ingress_ip_resource_group" {
  description = "Resource Group donde se encuentra la IP pública."
  value       = module.ingress_ip.resource_group
}
