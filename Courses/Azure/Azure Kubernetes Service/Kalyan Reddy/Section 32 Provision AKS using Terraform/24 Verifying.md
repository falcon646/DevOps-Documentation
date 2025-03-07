## Access Terraform created AKS cluster using AKS default admin
```
# Azure AKS Get Credentials with --admin
az aks get-credentials --resource-group aks-terraform-dev-rg  --name aks-terraform-dev-rg-aks-cluster --admin
az aks get-credentials --resource-group aks-terraform-dev-rg --name aks-terraform-dev-rg-aks-cluster --overwrite-existing

# Get Full Cluster Information
az aks show --resource-group aks-terraform-dev-rg --name aks-terraform-dev-rg-aks-cluster
az aks show --resource-group aks-terraform-dev-rg --name aks-terraform-dev-rg-aks-cluster -o table

# Get AKS Cluster Information using kubectl
kubectl cluster-info

# List Kubernetes Nodes
kubectl get nodes
```

## Verify Resources using Azure Management Console
- Resource Group
  - aks-terraform-dev-rg
  - aks-terraform-dev-rg-noderg
- AKS Cluster & Node Pool
  - Cluster: terraform-aks-dev-cluster
  - AKS System Pool
- Log Analytics Workspace
- Azure AD Group
  - terraform-aks-dev-cluster-administrators