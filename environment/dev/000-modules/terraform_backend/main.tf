# Resource Group para el estado de Terraform
resource "azurerm_resource_group" "terraform_state" {
  name     = var.resource_group_name
  location = var.location

  tags = merge(var.tags, {
    Purpose     = "terraform-backend"
    Module      = "terraform-backend"
  })
}

# Storage Account para el estado de Terraform
resource "azurerm_storage_account" "terraform_state" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.terraform_state.name
  location                 = azurerm_resource_group.terraform_state.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  # Habilitar soft delete para mayor seguridad
  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  tags = merge(var.tags, {
    Purpose     = "terraform-backend"
    Module      = "terraform-backend"
  })
}

# Container para los archivos de estado
resource "azurerm_storage_container" "terraform_state" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.terraform_state.name
  container_access_type = "private"
}
