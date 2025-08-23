terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.113"
    }
  }

  # Este módulo NO usa backend remoto porque es el que crea la infraestructura del backend
  # Se ejecuta localmente primero
}

provider "azurerm" {
  features {}
}

module "terraform_backend" {
  source              = "../000-modules/terraform_backend"
  resource_group_name = var.resource_group_name
  location            = var.location
  storage_account_name = var.storage_account_name
  container_name      = var.container_name
  tags                = merge(var.tags, {
    Environment = var.environment
    Module      = "terraform-backend"
  })
}
