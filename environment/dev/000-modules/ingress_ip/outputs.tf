output "public_ip" {
  value = azurerm_public_ip.this.ip_address
}

output "resource_group" {
  value = data.azurerm_kubernetes_cluster.aks.node_resource_group
}