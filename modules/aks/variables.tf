variable "name_prefix" {
  description = "Prefijo base para nombrar el cluster AKS."
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del Resource Group que contendrá el AKS."
  type        = string
}

variable "location" {
  description = "Región de Azure para el AKS."
  type        = string
}

variable "subnet_id" {
  description = "ID de la Subnet donde se ubicará el nodepool."
  type        = string
}

variable "uami_id" {
  description = "ID de la User Assigned Managed Identity usada por el AKS."
  type        = string
}

variable "kubernetes_version" {
  description = "Versión de Kubernetes (opcional). Si es null, Azure elegirá una válida."
  type        = string
  default     = null
}

variable "node_count" {
  description = "Cantidad de nodos del pool por defecto."
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "SKU de VM para el nodepool por defecto."
  type        = string
  default     = "Standard_A2_v2"
}

variable "tags" {
  description = "Etiquetas a aplicar al AKS."
  type        = map(string)
  default     = {}
}

variable "service_cidr" {
  description = "CIDR para Services (ClusterIP). Debe estar fuera del espacio de la VNet."
  type        = string
}

variable "dns_service_ip" {
  description = "IP del servicio DNS dentro de service_cidr."
  type        = string
}