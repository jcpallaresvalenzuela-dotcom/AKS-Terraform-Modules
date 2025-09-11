# Workflows de GitHub Actions - AKS Terraform Modules

Este repositorio contiene múltiples workflows de GitHub Actions para automatizar el despliegue, gestión y destrucción de infraestructura AKS utilizando una arquitectura modular de Terraform.

## Workflows Disponibles

### 1. Terraform Apply (Multi-Environment)
- **Archivo**: `terraform-apply-me.yml`
- **Propósito**: Despliega la infraestructura AKS completa en múltiples entornos
- **Trigger**: Manual con selección de entorno

### 2. AKS Cluster Management
- **Archivos**: `aks-start-cluster-dev.yml`, `aks-stop-cluster-dev.yml`
- **Propósito**: Gestiona el estado de encendido/apagado del cluster AKS
- **Triggers**: Manual y programado (stop diario a las 01:00 UTC)

### 3. Terraform Destroy
- **Archivo**: `terraform-destroy-dev.yml`
- **Propósito**: Destruye toda la infraestructura AKS en orden inverso
- **Trigger**: Manual

## Workflow Principal: Terraform Apply (Multi-Environment)

### Estructura del Workflow

```
validate-and-prepare (Job 0) - Validación y preparación
├── create-resource-group (Job 1) - Crea el Resource Group base
├── create-identity (Job 2) - Depende de Job 1
├── create-network (Job 3) - Depende de Job 1
├── create-aks (Job 4) - Depende de Jobs 2 y 3
├── create-ingress-ip (Job 5) - Depende de Job 4
└── verify-creation (Job 6) - Depende de todos los Jobs
```

### Orden de Ejecución

0. **validate-and-prepare**: Valida el entorno seleccionado y confirma el despliegue
1. **create-resource-group**: Crea el Resource Group base
2. **create-identity**: Crea la User Assigned Managed Identity
3. **create-network**: Crea la infraestructura de red (VNet y Subnet)
4. **create-aks**: Despliega el cluster AKS
5. **create-ingress-ip**: Crea la IP pública para ingress
6. **verify-creation**: Verifica el despliegue completo

## Configuración Requerida

### Secrets de GitHub

Los workflows requieren los siguientes secrets configurados en el repositorio:

#### Para Terraform Apply/Destroy (OIDC Authentication)
- `AZURE_CLIENT_ID`: Client ID del Service Principal
- `AZURE_TENANT_ID`: Tenant ID de Azure
- `AZURE_SUBSCRIPTION_ID`: Subscription ID de Azure
- `AZURE_STORAGE_ACCESS_KEY`: Access Key del Storage Account para el estado

#### Para AKS Start/Stop (Legacy Authentication)
- `AZURE_CREDENTIALS`: Credenciales completas del Service Principal (JSON)
- `AKS_NAME`: Nombre del cluster AKS
- `RESOURCE_GROUP`: Nombre del resource group

### Variables de Entorno

- `ENVIRONMENT`: Entorno de despliegue (dev, pre, pro)
- `TERRAFORM_VERSION`: Versión de Terraform (por defecto: "1.6.0")

## Funcionamiento del Workflow Principal

### 0. Validación y Preparación

- Valida que el entorno seleccionado existe
- Verifica que se confirma el despliegue
- Prepara el entorno para la ejecución

### 1. Despliegue del Resource Group

- Ejecuta `terraform init`, `plan` y `apply` en `./environment/{ENVIRONMENT}/020-resource_group`
- **USA backend remoto** en Azure Blob Storage
- Crea el Resource Group base para todos los recursos
- Verifica la existencia del módulo antes de ejecutar

### 2. Despliegue de Identity

- Ejecuta Terraform en `./environment/{ENVIRONMENT}/030-identity`
- **USA backend remoto** en Azure Blob Storage
- Depende del Resource Group (Job 1)
- Crea la User Assigned Managed Identity

### 3. Despliegue de Network

- Ejecuta Terraform en `./environment/{ENVIRONMENT}/040-network`
- **USA backend remoto** en Azure Blob Storage
- Depende del Resource Group (Job 1)
- Crea la infraestructura de red (VNet y Subnet)

### 4. Despliegue de AKS

- Ejecuta Terraform en `./environment/{ENVIRONMENT}/010-aks`
- **USA backend remoto** en Azure Blob Storage
- Depende de Identity y Network (Jobs 2 y 3)
- Espera a que el cluster esté listo antes de continuar
- Crea el cluster AKS con todas las configuraciones

### 5. Despliegue de Ingress IP

- Ejecuta Terraform en `./environment/{ENVIRONMENT}/050-ingress_ip`
- **USA backend remoto** en Azure Blob Storage
- Depende del AKS Cluster (Job 4)
- Crea la IP pública para ingress

### 6. Verificación del Despliegue

- Verifica la salud del cluster AKS
- Muestra un resumen completo del despliegue
- Lista todos los recursos creados

## Otros Workflows

### AKS Cluster Management

#### Start Cluster (`aks-start-cluster-dev.yml`)
- **Propósito**: Inicia un cluster AKS que esté detenido
- **Trigger**: Manual
- **Funcionalidad**:
  - Verifica el estado actual del cluster
  - Inicia el cluster si está detenido
  - Valida que el cluster esté funcionando correctamente

#### Stop Cluster (`aks-stop-cluster-dev.yml`)
- **Propósito**: Detiene un cluster AKS para ahorrar costos
- **Triggers**: Manual y programado (diario a las 01:00 UTC)
- **Funcionalidad**:
  - Verifica el estado actual del cluster
  - Detiene el cluster si está funcionando
  - Valida que el cluster se haya detenido correctamente

### Terraform Destroy (`terraform-destroy-dev.yml`)

#### Orden de Destrucción (Inverso al despliegue)
1. **destroy-ingress-ip**: Destruye la IP pública de ingress
2. **destroy-aks**: Destruye el cluster AKS
3. **destroy-network**: Destruye la infraestructura de red
4. **destroy-identity**: Destruye la identidad administrada
5. **destroy-resource-group**: Destruye el resource group
6. **verify-destruction**: Verifica la destrucción completa

## Características de los Workflows

### Gestión de Dependencias

- Utiliza `needs` para establecer dependencias entre jobs
- Los jobs se ejecutan en secuencia respetando las dependencias
- Garantiza el orden correcto de despliegue y destrucción

### Manejo de Estados

- **Todos los módulos**: Estado remoto en Azure Blob Storage
- Cada módulo mantiene su propio archivo de estado
- Los módulos se comunican a través de `terraform_remote_state`
- El workflow falla si cualquier job falla

### Verificación Automática

- Espera automáticamente a que el cluster AKS esté listo
- Verifica la salud del cluster después del despliegue
- Proporciona un resumen completo del despliegue/destrucción

## Uso de los Workflows

### Ejecución Manual

#### Terraform Apply (Multi-Environment)
1. Ve a la pestaña "Actions" en GitHub
2. Selecciona "Terraform Apply AKS Cluster - Modular Construction - ME"
3. Haz clic en "Run workflow"
4. Selecciona el entorno (dev, pre, pro)
5. Confirma el despliegue marcando la casilla
6. El workflow se ejecutará automáticamente en el orden correcto

#### AKS Cluster Management
1. Ve a la pestaña "Actions" en GitHub
2. Selecciona "Start AKS Cluster" o "Stop AKS Cluster"
3. Haz clic en "Run workflow"
4. El workflow verificará el estado y ejecutará la acción necesaria

#### Terraform Destroy
1. Ve a la pestaña "Actions" en GitHub
2. Selecciona "Terraform Destroy AKS Cluster - Modular Destruction"
3. Haz clic en "Run workflow"
4. El workflow destruirá todos los recursos en orden inverso

### Monitoreo

- Cada job muestra su progreso en tiempo real
- Los logs detallados están disponibles para cada paso
- El resumen final muestra todos los recursos desplegados/destruidos
- Los workflows incluyen verificaciones de salud del cluster

## Scripts de Utilidad

El repositorio incluye varios scripts en el directorio `scripts/` para facilitar la gestión:

### `create-simple-sp.sh`
- **Propósito**: Crea un Service Principal simple para GitHub Actions
- **Uso**: `./create-simple-sp.sh`
- **Funcionalidad**: Genera las credenciales necesarias para `AZURE_CREDENTIALS`

### `dev-aks-manual-deployment.sh`
- **Propósito**: Script para despliegue manual de todos los módulos
- **Uso**: `./dev-aks-manual-deployment.sh`
- **Funcionalidad**: Ejecuta terraform init/plan/apply en orden secuencial

### `az-get-credentials.sh`
- **Propósito**: Obtiene las credenciales del cluster AKS
- **Uso**: `./az-get-credentials.sh`
- **Funcionalidad**: Configura kubectl para conectarse al cluster

### `az-storage-blob-lease-break.sh`
- **Propósito**: Rompe leases de blobs en caso de problemas de estado
- **Uso**: `./az-storage-blob-lease-break.sh`
- **Funcionalidad**: Libera locks en el estado de Terraform

### `kube-config-generator.sh`
- **Propósito**: Genera configuración de kubectl
- **Uso**: `./kube-config-generator.sh`
- **Funcionalidad**: Crea archivos de configuración para kubectl

## Ventajas del Enfoque Modular

1. **Separación de Responsabilidades**: Cada módulo tiene su propio estado y configuración
2. **Despliegue Incremental**: Puedes desplegar solo los módulos que necesites
3. **Gestión de Estados**: Cada módulo mantiene su propio estado de Terraform
4. **Escalabilidad**: Fácil agregar nuevos módulos o modificar existentes
5. **Reutilización**: Los módulos pueden reutilizarse en otros entornos
6. **Multi-Environment**: Soporte para múltiples entornos (dev, pre, pro)
7. **Automatización Completa**: Workflows para crear, gestionar y destruir infraestructura

## ⚠️ **Orden Crítico de Despliegue**

**El workflow respeta automáticamente este orden:**

1. ✅ **validate-and-prepare** (validación)
2. ✅ **020-resource_group** (usa estado remoto)
3. ✅ **030-identity** (usa estado remoto)
4. ✅ **040-network** (usa estado remoto)
5. ✅ **010-aks** (usa estado remoto)
6. ✅ **050-ingress_ip** (usa estado remoto)
7. ✅ **verify-creation** (verificación final)

## ⚠️ **Orden Crítico de Destrucción**

**El workflow de destrucción respeta este orden (inverso):**

1. ✅ **050-ingress_ip** (destruye primero)
2. ✅ **010-aks** (destruye cluster)
3. ✅ **040-network** (destruye red)
4. ✅ **030-identity** (destruye identidad)
5. ✅ **020-resource_group** (destruye resource group)
6. ✅ **verify-destruction** (verificación final)
