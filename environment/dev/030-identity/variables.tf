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

variable "tags" {
  description = "Etiquetas comunes."
  type        = map(string)
  default     = {
    managedBy = "terraform"
    Project   = "aks-terraform"
  }
}
