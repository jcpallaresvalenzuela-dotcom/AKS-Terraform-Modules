# Ingress IP Module

Este módulo crea la IP pública estática necesaria para el ingress controller del cluster AKS.

## Uso

```bash
cd environment/dev/050-ingress_ip

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

## Outputs

- `ingress_public_ip`: IP pública asignada para el ingress
- `ingress_ip_resource_group`: Resource Group donde se encuentra la IP pública

## Estado Remoto

Este módulo utiliza Azure Blob Storage para el estado remoto de Terraform:
- Storage Account: ``
- Container: ``
- Key: `ingress-ip.tfstate`

## Dependencias

- AKS (010-aks)

## Orden de Despliegue

Este módulo debe ser desplegado después del cluster AKS.
