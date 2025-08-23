# Terraform Backend Module

Este módulo crea la infraestructura base necesaria para el backend remoto de Terraform en Azure.

## 🎯 **Propósito**

Crear los recursos mínimos necesarios para almacenar el estado de Terraform:
- Resource Group: `terraform-state-rg`
- Storage Account: `tfstatedev`
- Container: `tfstate`

## 📋 **Requisitos Previos**

- Azure CLI configurado y autenticado
- Terraform >= 1.6.0
- Permisos para crear Resource Groups y Storage Accounts en Azure

## 🚀 **Uso**

### 1. **Configurar Variables**

```bash
cd environment/dev/000-terraform_backend
cp terraform.tfvars.example terraform.tfvars
# Editar terraform.tfvars con los valores deseados
```

### 2. **Desplegar la Infraestructura**

```bash
# Inicializar Terraform
terraform init

# Planificar el despliegue
terraform plan

# Aplicar la configuración
terraform apply
```

### 3. **Verificar la Creación**

```bash
# Ver los outputs
terraform output

# Verificar en Azure
az storage account list --resource-group terraform-state-rg
az storage container list --account-name tfstatedev
```

## ⚠️ **Notas Importantes**

### **Nombres Únicos**
- El Storage Account debe tener un nombre **único globalmente** en Azure
- Si `tfstatedev` ya existe, cambia el nombre en `terraform.tfvars`

### **Región**
- Elige una región cercana a tu ubicación o donde planeas desplegar AKS
- Una vez creado, no se puede cambiar la región del Storage Account

### **Costos**
- Resource Group: Gratis
- Storage Account: ~$0.02/GB/mes (muy bajo para estado de Terraform)
- Container: Gratis

## 🔧 **Configuración del Backend**

Una vez creada la infraestructura, todos los módulos de Terraform usarán automáticamente:

```hcl
backend "azurerm" {
  resource_group_name  = "terraform-state-rg"
  storage_account_name = "tfstatedev"
  container_name       = "tfstate"
  key                  = "[nombre-del-modulo].tfstate"
}
```

## 🗑️ **Eliminación**

Si necesitas eliminar la infraestructura del backend:

```bash
terraform destroy
```

**⚠️ ADVERTENCIA**: Esto eliminará TODOS los archivos de estado de Terraform. Solo hazlo si estás seguro de que no los necesitas.

## 📁 **Estructura de Archivos de Estado**

Después del despliegue, se crearán automáticamente:

```
tfstate/
├── resource-group.tfstate
├── identity.tfstate
├── network.tfstate
├── aks.tfstate
└── ingress-ip.tfstate
```

## 🔐 **Seguridad**

- Container configurado como `private`
- Soft delete habilitado (7 días)
- TLS 1.2 mínimo requerido
- Acceso solo a través de Azure AD o claves de acceso
