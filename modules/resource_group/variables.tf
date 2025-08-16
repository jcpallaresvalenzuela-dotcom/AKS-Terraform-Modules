variable "name_prefix" {
  description = "Prefijo base para nombrar el Resource Group."
  type        = string
}

variable "location" {
  description = "Región de Azure para el Resource Group."
  type        = string
}

variable "tags" {
  description = "Etiquetas a aplicar al Resource Group."
  type        = map(string)
  default     = {}
}
