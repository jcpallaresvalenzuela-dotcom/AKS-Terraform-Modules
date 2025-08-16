resource "azurerm_kubernetes_cluster" "this" {
  name                = "${var.name_prefix}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.name_prefix}-dns"
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name            = "system"
    vm_size         = var.vm_size
    node_count      = var.node_count
    vnet_subnet_id  = var.subnet_id
    type            = "VirtualMachineScaleSets"
    os_disk_size_gb = 30
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.uami_id]
  }

  network_profile {
    network_plugin       = "azure"     # Azure CNI
    network_policy       = "azure"
    load_balancer_sku    = "standard"
    outbound_type        = "loadBalancer"

    service_cidr         = var.service_cidr
    dns_service_ip       = var.dns_service_ip
}


  tags = var.tags
}
