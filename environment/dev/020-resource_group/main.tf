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
    key                  = "resource-group.tfstate"
  }
}

provider "azurerm" {
  features {}
}

module "resource_group" {
  source      = "../000-modules/resource_group"
  name_prefix = "${var.name_prefix}-${var.environment}"
  location    = var.location
  tags        = merge(var.tags, {
    Environment = var.environment
    Module      = "resource-group"
  })
}
