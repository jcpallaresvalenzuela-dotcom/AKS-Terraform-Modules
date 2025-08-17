variable "name_prefix" {
  description = "Prefijo base para nombrar recursos (kebab-case, corto)."
  type        = string
  sensitive   = true
}

variable "location" {
  description = "Región de Azure."
  type        = string
  default     = "East US"
  sensitive   = true
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

variable "node_count" {
  description = "Cantidad de nodos del pool del sistema."
  type        = number
  default     = 1
  sensitive   = true
}

variable "vm_size" {
  description = "SKU de VM para el nodepool."
  type        = string
  default     = "Standard_A2_v2"
  sensitive   = true
}

variable "kubernetes_version" {
  description = "Versión de Kubernetes (opcional). Si se omite, Azure elegirá una válida."
  type        = string
  default     = null
  sensitive   = true
}

variable "tags" {
  description = "Etiquetas comunes."
  type        = map(string)
  default     = {
    environment = "dev"
    managedBy   = "terraform"
  }
}

variable "service_cidr" {
  description = "CIDR para los ClusterIP Services de Kubernetes (no debe solaparse con la VNet/Subnets)."
  type        = string
  default     = "10.240.0.0/16"
  sensitive   = true
}

variable "dns_service_ip" {
  description = "IP del kube-dns/CoreDNS dentro de service_cidr."
  type        = string
  default     = "10.240.0.10"
  sensitive   = true
}


