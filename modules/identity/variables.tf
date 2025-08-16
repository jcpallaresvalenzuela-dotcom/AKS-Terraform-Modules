variable "name_prefix" {
  description = "Prefijo base para nombrar la identidad administrada."
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del Resource Group donde se crea la identidad."
  type        = string
}

variable "location" {
  description = "Región de Azure para la identidad."
  type        = string
}

variable "tags" {
  description = "Etiquetas a aplicar a la identidad."
  type        = map(string)
  default     = {}
}
