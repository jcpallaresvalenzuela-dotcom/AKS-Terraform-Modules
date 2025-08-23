# Workflow de Despliegue Modular - Entorno de Desarrollo

Este workflow de GitHub Actions automatiza el despliegue completo de la infraestructura AKS utilizando la nueva arquitectura modular de Terraform.

## Descripción del Workflow

El workflow `terraform-apply.yml` despliega todos los módulos de Terraform en el orden correcto, respetando las dependencias entre recursos.

## Estructura del Workflow

### Jobs y Dependencias

```
deploy-terraform-backend (Job 0) - Crea la infraestructura del backend
├── deploy-resource-group (Job 1) - Depende de Job 0
├── deploy-identity (Job 2) - Depende de Job 1
├── deploy-network (Job 3) - Depende de Job 1
└── deploy-aks (Job 4) - Depende de Jobs 1, 2 y 3
    └── deploy-ingress-ip (Job 5) - Depende de Job 4
        └── verify-deployment (Job 6) - Depende de todos los Jobs
```

### Orden de Ejecución

0. **deploy-terraform-backend**: Crea la infraestructura del backend de Terraform
1. **deploy-resource-group**: Crea el Resource Group base
2. **deploy-identity**: Crea la User Assigned Managed Identity
3. **deploy-network**: Crea la infraestructura de red (VNet y Subnet)
4. **deploy-aks**: Despliega el cluster AKS
5. **deploy-ingress-ip**: Crea la IP pública para ingress
6. **verify-deployment**: Verifica el despliegue completo

## Configuración Requerida

### Secrets de GitHub

El workflow requiere los siguientes secrets configurados en el repositorio:

- `AZURE_CREDENTIALS`: Credenciales de Azure Service Principal
- `AKS_NAME`: Nombre del cluster AKS (opcional, se obtiene del output)
- `RESOURCE_GROUP`: Nombre del resource group (opcional, se obtiene del output)

### Variables de Entorno

- `ENVIRONMENT`: Entorno de despliegue (por defecto: "dev")
- `TERRAFORM_VERSION`: Versión de Terraform (por defecto: "1.6.0")

## Funcionamiento del Workflow

### 0. Despliegue de la Infraestructura del Backend

- Ejecuta `terraform init`, `plan` y `apply` en `./environment/dev/000-terraform_backend`
- **NO usa backend remoto** (se ejecuta localmente)
- Crea: Resource Group, Storage Account y Container
- Captura los outputs: `resource_group_name`, `storage_account_name`, `container_name`

### 1. Despliegue del Resource Group

- Ejecuta `terraform init`, `plan` y `apply` en `./environment/dev/020-resource_group`
- **USA backend remoto** creado por el Job 0
- Captura los outputs: `resource_group_name` y `resource_group_location`
- Depende del Job 0 (backend)

### 2. Despliegue de Identity

- Ejecuta Terraform en `./environment/dev/030-identity`
- **USA backend remoto** creado por el Job 0
- Depende del Resource Group (Job 1)
- Captura los outputs: `identity_id` y `identity_principal_id`

### 3. Despliegue de Network

- Ejecuta Terraform en `./environment/dev/040-network`
- **USA backend remoto** creado por el Job 0
- Depende del Resource Group (Job 1)
- Captura los outputs: `vnet_id` y `subnet_id`

### 4. Despliegue de AKS

- Ejecuta Terraform en `./environment/dev/010-aks`
- **USA backend remoto** creado por el Job 0
- Depende de Resource Group, Identity y Network (Jobs 1, 2 y 3)
- Espera a que el cluster esté listo antes de continuar
- Captura los outputs: `aks_name` y `resource_group_name`

### 5. Despliegue de Ingress IP

- Ejecuta Terraform en `./environment/dev/050-ingress_ip`
- **USA backend remoto** creado por el Job 0
- Depende del AKS Cluster (Job 4)
- Captura el output: `ingress_public_ip`

### 6. Verificación del Despliegue

- Obtiene las credenciales del cluster AKS
- Verifica la salud del cluster
- Muestra un resumen completo del despliegue

## Características del Workflow

### Gestión de Dependencias

- Utiliza `needs` para establecer dependencias entre jobs
- **El Job 0 (backend) se ejecuta primero y es independiente**
- Los jobs posteriores dependen del backend y se ejecutan en secuencia
- Garantiza el orden correcto de despliegue

### Manejo de Estados

- **Job 0**: Estado local (sin backend remoto)
- **Jobs 1-5**: Estado remoto en Azure Blob Storage
- Cada job captura sus outputs para uso posterior
- Los outputs se pasan entre jobs según sea necesario
- El workflow falla si cualquier job falla

### Verificación Automática

- Espera automáticamente a que el cluster AKS esté listo
- Verifica la salud del cluster después del despliegue
- Proporciona un resumen completo del despliegue

## Uso del Workflow

### Ejecución Manual

1. Ve a la pestaña "Actions" en GitHub
2. Selecciona "Terraform Apply AKS Cluster - Modular Deployment"
3. Haz clic en "Run workflow"
4. El workflow se ejecutará automáticamente en el orden correcto

### Monitoreo

- Cada job muestra su progreso en tiempo real
- Los logs detallados están disponibles para cada paso
- El resumen final muestra todos los recursos desplegados

### Troubleshooting

- Si un job falla, revisa los logs del job específico
- Los jobs posteriores no se ejecutarán hasta que se resuelva el error
- Puedes re-ejecutar el workflow desde el punto de falla

## Ventajas del Enfoque Modular

1. **Separación de Responsabilidades**: Cada módulo tiene su propio estado y configuración
2. **Despliegue Incremental**: Puedes desplegar solo los módulos que necesites
3. **Gestión de Estados**: Cada módulo mantiene su propio estado de Terraform
4. **Escalabilidad**: Fácil agregar nuevos módulos o modificar existentes
5. **Reutilización**: Los módulos pueden reutilizarse en otros entornos

## Notas Importantes

- **Job 0 (backend) se ejecuta localmente** sin estado remoto
- **Jobs 1-5 usan el estado remoto** creado por el Job 0
- **Cada módulo mantiene su propio archivo de estado** en Azure Blob Storage
- **Los módulos se comunican a través de `terraform_remote_state`**
- **Los nombres de recursos incluyen automáticamente el prefijo y el entorno**
- **Todos los recursos están etiquetados apropiadamente** para costos y organización

## ⚠️ **Orden Crítico de Despliegue**

**El workflow respeta automáticamente este orden:**

1. ✅ **000-terraform_backend** (estado local)
2. ✅ **020-resource_group** (usa estado remoto)
3. ✅ **030-identity** (usa estado remoto)
4. ✅ **040-network** (usa estado remoto)
5. ✅ **010-aks** (usa estado remoto)
6. ✅ **050-ingress_ip** (usa estado remoto)
7. ✅ **verify-deployment** (verificación final)
