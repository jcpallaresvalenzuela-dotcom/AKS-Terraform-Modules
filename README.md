# AKS Minimal Cluster – Terraform

Despliegue de un cluster de Kubernetes en Azure (AKS) utilizando Terraform con módulos locales.
La configuración es minimalista (1 nodo por defecto), pensada para entornos de desarrollo o pruebas.


## Tecnologías usadas

[Terraform](https://www.terraform.io/) >= 1.6

[Azure Kubernetes Service](https://azure.microsoft.com/en-us/services/kubernetes-service/) (AKS) 

[Azure Resource Manager](https://docs.microsoft.com/en-us/azure/azure-resource-manager/) (ARM)

[Azure User Assigned Managed Identity](https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview) (UAMI)

[Azure VNet & Subnet](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview)


## Estructura del proyecto

```sh
├── main.tf                 # Composición principal de módulos
├── variables.tf            # Variables globales
├── outputs.tf              # Outputs exportados
├── providers.tf            # Configuración de providers
├── terraform.tfvars        # Valores personalizados
└── modules/                # Módulos locales
    ├── resource_group/
    ├── network/
    ├── identity/
    └── aks/
```
## Variables principales

Definidas en variables.tf con valores personalizables en terraform.tfvars.

| Variable         | Descripción                             | Default          |
| ---------------- | --------------------------------------- | ---------------- |
| `name_prefix`    | Prefijo base para nombrar recursos      | –                |
| `location`       | Región de Azure                         | `East US`        |
| `vnet_cidr`      | CIDR de la VNet                         | `10.0.0.0/16`    |
| `subnet_cidr`    | CIDR de la Subnet para AKS              | `10.0.1.0/24`    |
| `node_count`     | Nodos del pool por defecto              | `1`              |
| `vm_size`        | SKU de VM para nodos                    | `Standard_A2_v2` |
| `service_cidr`   | CIDR para ClusterIP Services            | `10.240.0.0/16`  |
| `dns_service_ip` | IP de kube-dns dentro de `service_cidr` | `10.240.0.10`    |
| `tags`           | Etiquetas comunes                       | `{}`             |

## Uso

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

Obtener kubeconfig

```bash
terraform output -raw kubeconfig_raw > ~/.kube/config
```
## Referencias

Referencias

* [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

* [Azure AKS Documentation](https://learn.microsoft.com/en-us/azure/aks/)

* [Best Practices for AKS Networking](https://learn.microsoft.com/en-us/azure/aks/configure-azure-cni)