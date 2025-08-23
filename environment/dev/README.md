# Entorno de Desarrollo - AKS Terraform

Este directorio contiene la configuración de Terraform para desplegar un cluster AKS en el entorno de desarrollo.

## Estructura del Proyecto

```
environment/dev/
├── 000-modules/           # Módulos reutilizables
│   ├── aks/              # Módulo del cluster AKS
│   ├── identity/         # Módulo de identidad administrada
│   ├── ingress_ip/       # Módulo de IP pública para ingress
│   ├── network/          # Módulo de infraestructura de red
│   ├── resource_group/   # Módulo de resource group
│   └── terraform_backend/ # Módulo de infraestructura del backend
├── 000-terraform_backend/ # Despliegue de la infraestructura del backend
├── 010-aks/              # Despliegue del cluster AKS
├── 020-resource_group/   # Despliegue del resource group
├── 030-identity/         # Despliegue de la identidad
├── 040-network/          # Despliegue de la red
├── 050-ingress_ip/       # Despliegue de la IP pública
└── README.md             # Este archivo
```

## Orden de Despliegue

Los módulos deben ser desplegados en el siguiente orden debido a las dependencias:

0. **000-terraform_backend**: Crea la infraestructura del backend de Terraform
1. **020-resource_group**: Crea el resource group base
2. **030-identity**: Crea la identidad administrada
3. **040-network**: Crea la infraestructura de red
4. **010-aks**: Despliega el cluster AKS
5. **050-ingress_ip**: Crea la IP pública para ingress

## Estado Remoto

Cada módulo utiliza su propio archivo de estado remoto en Azure Blob Storage:

- **Backend**: `terraform-backend.tfstate` (estado local)
- **Resource Group**: `resource-group.tfstate`
- **Identity**: `identity.tfstate`
- **Network**: `network.tfstate`
- **AKS**: `aks.tfstate`
- **Ingress IP**: `ingress-ip.tfstate`

### Configuración del Backend

Todos los módulos (excepto el de backend) utilizan la siguiente configuración de backend:

```hcl
backend "azurerm" {
  resource_group_name  = "terraform-state-rg"
  storage_account_name = "tfstatedev"
  container_name       = "tfstate"
  key                  = "[nombre-del-modulo].tfstate"
}
```

## Configuración

### Variables Comunes

Todos los módulos requieren las siguientes variables:

- `name_prefix`: Prefijo base para nombrar recursos
- `environment`: Entorno de despliegue (por defecto: "dev")

### Archivos de Configuración

Cada módulo incluye:
- `terraform.tfvars.example`: Archivo de ejemplo de configuración
- `README.md`: Documentación específica del módulo

## Despliegue

### 0. **Configurar y Desplegar el Backend (PRIMERO)**

```bash
cd environment/dev/000-terraform_backend
cp terraform.tfvars.example terraform.tfvars
# Editar terraform.tfvars con los valores deseados
terraform init
terraform plan
terraform apply
```

### 1. **Configurar Variables para los Módulos**

Para cada módulo, copia el archivo de ejemplo y ajusta los valores:

```bash
cd environment/dev/[nombre-del-modulo]
cp terraform.tfvars.example terraform.tfvars
# Editar terraform.tfvars con los valores deseados
```

### 2. **Desplegar en Orden**

```bash
# 1. Resource Group
cd environment/dev/020-resource_group
terraform init
terraform plan
terraform apply

# 2. Identity
cd ../030-identity
terraform init
terraform plan
terraform apply

# 3. Network
cd ../040-network
terraform init
terraform plan
terraform apply

# 4. AKS
cd ../010-aks
terraform init
terraform plan
terraform apply

# 5. Ingress IP
cd ../050-ingress_ip
terraform init
terraform plan
terraform apply
```

## Tags

Todos los recursos incluyen automáticamente los siguientes tags:

- `Environment = "dev"`
- `Module = "[nombre-del-módulo]"`
- `managedBy = "terraform"`
- `Project = "aks-terraform"`

## Requisitos Previos

- Azure CLI configurado y autenticado
- Terraform >= 1.6.0
- **IMPORTANTE**: El módulo `000-terraform_backend` debe ejecutarse PRIMERO para crear la infraestructura del backend

## Notas Importantes

- **El módulo de backend se ejecuta localmente** (sin estado remoto)
- **Los demás módulos usan el estado remoto** creado por el módulo de backend
- Cada módulo mantiene su propio estado de Terraform
- Los módulos se comunican a través de `terraform_remote_state`
- Los nombres de recursos incluyen automáticamente el prefijo y el entorno
- Todos los recursos están etiquetados apropiadamente para costos y organización

## ⚠️ **Orden Crítico de Despliegue**

**NO ejecutes ningún otro módulo hasta que el módulo de backend esté completamente desplegado:**

1. ✅ **000-terraform_backend** (PRIMERO - estado local)
2. ✅ **020-resource_group** (usa estado remoto)
3. ✅ **030-identity** (usa estado remoto)
4. ✅ **040-network** (usa estado remoto)
5. ✅ **010-aks** (usa estado remoto)
6. ✅ **050-ingress_ip** (usa estado remoto)
