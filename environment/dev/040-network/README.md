# Network Module

Este módulo crea la infraestructura de red necesaria para el cluster AKS.

## Uso

```bash
cd environment/dev/040-network

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
- `vnet_cidr`: CIDR para la VNet
- `subnet_cidr`: CIDR para la Subnet de AKS
- `tags`: Etiquetas adicionales

**Nota**: `resource_group_name` y `location` se obtienen automáticamente del estado remoto del módulo `020-resource_group`.

## Outputs

- `vnet_id`: ID de la Virtual Network creada
- `subnet_id`: ID de la Subnet de AKS

## Estado Remoto

Este módulo utiliza Azure Blob Storage para el estado remoto de Terraform:
- Storage Account: ``
- Container: ``
- Key: `network.tfstate`

## Dependencias

- Resource Group (020-resource_group) - **OBLIGATORIA**

## Comunicación con Otros Módulos

Este módulo lee automáticamente:
- `resource_group_name` del estado remoto de `020-resource_group`
- `location` del estado remoto de `020-resource_group`

No es necesario configurar estas variables manualmente.
