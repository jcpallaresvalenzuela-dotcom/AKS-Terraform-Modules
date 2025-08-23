variable "resource_group_name" {
  description = "Nombre del Resource Group para el estado de Terraform."
  type        = string
  default     = "terraform-state-rg"
}

variable "environment" {
  description = "Entorno de despliegue (dev, pre, pro)."
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Región de Azure donde se creará la infraestructura del backend."
  type        = string
  default     = "East US"
}

variable "storage_account_name" {
  description = "Nombre del Storage Account para el estado de Terraform (debe ser único globalmente)."
  type        = string
  default     = "tfstatedev"
}

variable "container_name" {
  description = "Nombre del container para los archivos de estado."
  type        = string
  default     = "tfstate"
}

variable "tags" {
  description = "Etiquetas comunes."
  type        = map(string)
  default     = {
    managedBy = "terraform"
    Project   = "aks-terraform"
  }
}
