variable "name_prefix" {
  description = "Prefijo base para nombrar recursos (kebab-case, corto)."
  type        = string
  default     = "myproject"
  sensitive   = true
}

variable "environment" {
  description = "Entorno de despliegue (dev, pre, pro)."
  type        = string
  default     = "dev"
}

variable "vnet_cidr" {
  description = "CIDR para la VNet."
  type        = string
  default     = "10.0.0.0/16"
  sensitive   = true
}

variable "subnet_cidr" {
  description = "CIDR para la Subnet de AKS."
  type        = string
  default     = "10.0.1.0/24"
  sensitive   = true
}

variable "tags" {
  description = "Etiquetas comunes."
  type        = map(string)
  default     = {
    managedBy = "terraform"
    Project   = "aks-terraform"
  }
}
