### **Creating Azure AKS Node Pools Using Terraform**  

This section covers the process of creating **Linux and Windows node pools** in an **Azure Kubernetes Service (AKS) cluster** using Terraform. The deployment will include **node selectors** for workload placement.  

- **Creating an AKS Linux User Node Pool**  
Terraform defines an **Azure Kubernetes Service (AKS) node pool** using the `azurerm_kubernetes_cluster_node_pool` resource.  

### **Terraform Documentation Reference**
The **`azurerm_kubernetes_cluster_node_pool`** resource is referenced from the **AzureRM Terraform provider documentation**.  

Basic attributes required:  
- `name`: Node pool name  
- `kubernetes_cluster_id`: Reference to the AKS cluster  
- `vm_size`: Azure VM SKU  
- `node_count`: Number of nodes  
- `mode`: Defines **System** or **User** mode  

**Terraform Code:**
```hcl
resource "azurerm_kubernetes_cluster_node_pool" "aks-user-nodepool" {
    name                    = "usernodepool"
    kubernetes_cluster_id   = azurerm_kubernetes_cluster.aks_cluster.id
    os_type                 = "Linux"
    vm_size                 = "Standard_DS2_v2"
    auto_scaling_enabled    = true
    orchestrator_version    = data.azurerm_kubernetes_service_versions.current.latest_version
    max_count               = 2
    min_count               = 1
    os_disk_size_gb         = 30
    mode                    = "User"

    node_labels = {
      "nodepool-type"    = "user"
      "environment"      = var.environment
      "nodepoolos"       = "linux"
      "app"              = "java-apps"
    } 

    tags = {
      "nodepool-type"    = "user"
      "environment"      = var.environment
      "nodepoolos"       = "linux"
      "app"              = "java-apps"
    } 
}
```


- **Node Pool Name:** `"usernodepool"`  
- **Cluster Reference:** `azurerm_kubernetes_cluster.aks_cluster.id`  
- **VM Size:** `Standard_DS2_v2` (A general-purpose VM)  
- **Auto Scaling:** Enabled with `min_count = 1` and `max_count = 2`  
- **Disk Size:** `30 GB`  
- **Mode:** `"User"` (as opposed to **System**)  
- **Labels & Tags:**  
  - `"nodepool-type"`: `"user"`  
  - `"environment"`: Dynamically set using `var.environment`  
  - `"nodepoolos"`: `"linux"`  
  - `"app"`: `"java-apps"`  

## Verify if Nodepools added successfully
```
# List Node Pools
az aks nodepool list --resource-group <rg-name> --cluster-name  <cluster-name> --output table

# List Nodes using Labels
kubectl get nodes -o wide
kubectl get nodes -o wide -l nodepoolos=linux
kubectl get nodes -o wide -l nodepoolos=windows
kubectl get nodes -o wide -l environment=dev
```