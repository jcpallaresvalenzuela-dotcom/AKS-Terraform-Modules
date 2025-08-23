variable "resource_group_name" {
  description = "Nombre del Resource Group para el estado de Terraform."
  type        = string
}

variable "location" {
  description = "Región de Azure donde se creará la infraestructura del backend."
  type        = string
}

variable "storage_account_name" {
  description = "Nombre del Storage Account para el estado de Terraform (debe ser único globalmente)."
  type        = string
}

variable "container_name" {
  description = "Nombre del container para los archivos de estado."
  type        = string
}

variable "tags" {
  description = "Etiquetas a aplicar a los recursos del backend."
  type        = map(string)
  default     = {}
}
