# Resource Group Module

Este módulo crea el Resource Group base para todos los recursos de AKS en el entorno de desarrollo.

## Uso

```bash
cd environment/dev/020-resource_group

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
- `tags`: Etiquetas adicionales

## Outputs

- `resource_group_name`: Nombre del Resource Group creado
- `resource_group_location`: Ubicación del Resource Group
- `resource_group_id`: ID del Resource Group

## Estado Remoto

Este módulo utiliza Azure Blob Storage para el estado remoto de Terraform:
- Storage Account: ``
- Container: ``
- Key: `resource-group.tfstate`

## Dependencias

Este módulo no tiene dependencias y debe ser desplegado primero.
