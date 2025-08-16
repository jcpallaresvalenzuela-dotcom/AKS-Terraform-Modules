output "name" {
  value = azurerm_kubernetes_cluster.this.name
}

output "kubeconfig_raw" {
  value     = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive = true
}
