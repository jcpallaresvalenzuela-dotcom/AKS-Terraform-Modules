# 1. Resource Group
cd environment/dev/020-resource_group
terraform init && terraform plan && terraform apply

# 2. Identity
cd ../030-identity
terraform init && terraform plan && terraform apply

# 3. Network
cd ../040-network
terraform init && terraform plan && terraform apply

# 4. AKS
cd ../010-aks
terraform init && terraform plan && terraform apply

# 5. Ingress IP
cd ../050-ingress_ip
terraform init && terraform plan && terraform apply