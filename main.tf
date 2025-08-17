module "rg" {
  source     = "./modules/resource_group"
  name_prefix = var.name_prefix
  location    = var.location
  tags        = var.tags
}

module "uami" {
  source              = "./modules/identity"
  name_prefix         = var.name_prefix
  resource_group_name = module.rg.name
  location            = module.rg.location
  tags                = var.tags
}

module "net" {
  source              = "./modules/network"
  name_prefix         = var.name_prefix
  resource_group_name = module.rg.name
  location            = module.rg.location
  vnet_cidr           = var.vnet_cidr
  subnet_cidr         = var.subnet_cidr
  tags                = var.tags
}

# Otorga permisos de red al identity ANTES de crear AKS (evita ciclos)
resource "azurerm_role_assignment" "subnet_network_contributor" {
  scope                = module.net.subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = module.uami.principal_id
}

module "aks" {
  source              = "./modules/aks"
  name_prefix         = var.name_prefix
  resource_group_name = module.rg.name
  location            = module.rg.location
  subnet_id           = module.net.subnet_id
  uami_id             = module.uami.id
  kubernetes_version  = var.kubernetes_version
  node_count          = var.node_count
  vm_size             = var.vm_size
  tags                = var.tags
  service_cidr        = var.service_cidr
  dns_service_ip      = var.dns_service_ip


  depends_on = [azurerm_role_assignment.subnet_network_contributor]
}

module "ingress_ip" {
  source              = "./modules/ingress_ip"
  aks_name            = module.aks.name
  aks_rg              = module.aks.resource_group_name
  ip_name             = "aks-game-ingress-ip"
  
  depends_on = [module.aks]
}