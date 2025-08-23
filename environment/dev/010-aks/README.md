# AKS Module

Este módulo despliega el cluster Azure Kubernetes Service (AKS) utilizando los recursos creados por los módulos anteriores.

## Uso

```bash
cd environment/dev/010-aks

# Inicializar Terraform
terraform init

# Planificar el despliegue
terraform plan

# Aplicar la configuración
terraform apply
```

## Variables

- `name_prefix`: Prefijo base para nombrar recursos
- `environment`: Entorno de despliegue (dev, pre, pro)
- `location`: Región de Azure
- `vnet_cidr`: CIDR para la VNet (se obtiene del estado remoto)
- `subnet_cidr`: CIDR para la Subnet de AKS (se obtiene del estado remoto)
- `node_count`: Cantidad de nodos del pool del sistema
- `vm_size`: SKU de VM para el nodepool
- `kubernetes_version`: Versión de Kubernetes
- `service_cidr`: CIDR para los ClusterIP Services
- `dns_service_ip`: IP del kube-dns/CoreDNS
- `tags`: Etiquetas adicionales

## Outputs

- `resource_group_name`: Nombre del Resource Group del AKS
- `aks_name`: Nombre del cluster AKS
- `kubeconfig_raw`: Kubeconfig en texto (sensitivo)

## Estado Remoto

Este módulo utiliza Azure Blob Storage para el estado remoto de Terraform:
- Storage Account: `tfstatedev`
- Container: `tfstate`
- Key: `aks.tfstate`

## Dependencias

- Resource Group (020-resource_group)
- Identity (030-identity)
- Network (040-network)

## Orden de Despliegue

1. Resource Group (020-resource_group)
2. Identity (030-identity)
3. Network (040-network)
4. AKS (010-aks)
5. Ingress IP (050-ingress_ip)