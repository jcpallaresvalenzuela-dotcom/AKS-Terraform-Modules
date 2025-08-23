output "vnet_id" {
  description = "ID de la Virtual Network creada."
  value       = module.network.vnet_id
}

output "subnet_id" {
  description = "ID de la Subnet de AKS."
  value       = module.network.subnet_id
}
