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
    key                  = "ingress-ip.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Data source para obtener información del AKS ya desplegado
data "terraform_remote_state" "aks" {
  backend = "azurerm"
  config = {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "jcpallarestfstatedev"
    container_name       = "jcpallarestfstate"
    key                  = "aks.tfstate"
  }
}

module "ingress_ip" {
  source   = "../000-modules/ingress_ip"
  aks_name = data.terraform_remote_state.aks.outputs.aks_name
  aks_rg   = data.terraform_remote_state.aks.outputs.resource_group_name
  ip_name  = "${var.name_prefix}-${var.environment}-aks-game-ingress-ip"
}
