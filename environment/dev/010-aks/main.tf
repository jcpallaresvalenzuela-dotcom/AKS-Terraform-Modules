terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.113"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "jcpallarestfstatedev"
    container_name       = "jcpallarestfstate"
    key                  = "aks.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Data sources para obtener información de los recursos ya desplegados
data "terraform_remote_state" "resource_group" {
  backend = "azurerm"
  config = {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "jcpallarestfstatedev"
    container_name       = "jcpallarestfstate"
    key                  = "resource-group.tfstate"
  }
}

data "terraform_remote_state" "identity" {
  backend = "azurerm"
  config = {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "jcpallarestfstatedev"
    container_name       = "jcpallarestfstate"
    key                  = "identity.tfstate"
  }
}

data "terraform_remote_state" "network" {
  backend = "azurerm"
  config = {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "jcpallarestfstatedev"
    container_name       = "jcpallarestfstate"
    key                  = "network.tfstate"
  }
}

# Otorga permisos de red al identity ANTES de crear AKS (evita ciclos)
resource "azurerm_role_assignment" "subnet_network_contributor" {
  scope                = data.terraform_remote_state.network.outputs.subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = data.terraform_remote_state.identity.outputs.identity_principal_id
}

module "aks" {
  source              = "../000-modules/aks"
  name_prefix         = "${var.name_prefix}-${var.environment}"
  resource_group_name = data.terraform_remote_state.resource_group.outputs.resource_group_name
  location            = data.terraform_remote_state.resource_group.outputs.resource_group_location
  subnet_id           = data.terraform_remote_state.network.outputs.subnet_id
  uami_id             = data.terraform_remote_state.identity.outputs.identity_id
  kubernetes_version  = var.kubernetes_version
  node_count          = var.node_count
  vm_size             = var.vm_size
  tags                = merge(var.tags, { #REVISAR ESTE MERGE DE TAGS
    Environment = var.environment
    Module      = "aks"
  })
  service_cidr        = var.service_cidr
  dns_service_ip      = var.dns_service_ip

  depends_on = [azurerm_role_assignment.subnet_network_contributor]
}