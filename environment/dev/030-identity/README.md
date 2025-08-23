# Identity Module

Este módulo crea la User Assigned Managed Identity necesaria para el cluster AKS.

## Uso

```bash
cd environment/dev/030-identity

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
- `tags`: Etiquetas adicionales

**Nota**: `resource_group_name` y `location` se obtienen automáticamente del estado remoto del módulo `020-resource_group`.

## Outputs

- `identity_id`: ID de la User Assigned Managed Identity
- `identity_client_id`: Client ID de la identidad
- `identity_principal_id`: Principal ID de la identidad
- `identity_name`: Nombre de la identidad

## Estado Remoto

Este módulo utiliza Azure Blob Storage para el estado remoto de Terraform:
- Storage Account: ``
- Container: ``
- Key: `identity.tfstate`

## Dependencias

- Resource Group (020-resource_group) - **OBLIGATORIA**

## Comunicación con Otros Módulos

Este módulo lee automáticamente:
- `resource_group_name` del estado remoto de `020-resource_group`
- `location` del estado remoto de `020-resource_group`

No es necesario configurar estas variables manualmente.
