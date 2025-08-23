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
