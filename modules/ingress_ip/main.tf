data "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  resource_group_name = var.aks_rg
}

resource "azurerm_public_ip" "this" {
  name                = var.ip_name
  location            = data.azurerm_kubernetes_cluster.aks.location
  resource_group_name = data.azurerm_kubernetes_cluster.aks.node_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
}