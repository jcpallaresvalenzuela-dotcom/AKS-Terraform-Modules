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
    key                  = "identity.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Data source para obtener información del Resource Group ya desplegado
data "terraform_remote_state" "resource_group" {
  backend = "azurerm"
  config = {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "jcpallarestfstatedev"
    container_name       = "jcpallarestfstate"
    key                  = "resource-group.tfstate"
  }
}

module "identity" {
  source              = "../000-modules/identity"
  name_prefix         = "${var.name_prefix}-${var.environment}"
  resource_group_name = data.terraform_remote_state.resource_group.outputs.resource_group_name
  location            = data.terraform_remote_state.resource_group.outputs.resource_group_location
  tags                = merge(var.tags, {
    Environment = var.environment
    Module      = "identity"
  })
}
