variable "name_prefix" {
  description = "Prefijo base para nombrar recursos de red."
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del Resource Group donde se crea la red."
  type        = string
}

variable "location" {
  description = "Región de Azure para los recursos de red."
  type        = string
}

variable "vnet_cidr" {
  description = "CIDR para la VNet."
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR para la Subnet de AKS."
  type        = string
}

variable "tags" {
  description = "Etiquetas a aplicar a los recursos de red."
  type        = map(string)
  default     = {}
}
