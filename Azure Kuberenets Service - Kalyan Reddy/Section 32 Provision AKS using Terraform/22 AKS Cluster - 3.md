### **Configuring Linux Profile and Network Profile in an AKS Cluster using Terraform**  

This section covers:  
1. **Linux Profile Configuration**  
2. **Network Profile Configuration**  

- **Configuring Linux Profile**  : The **Linux profile** is required to set up an **admin user** for the AKS nodes and configure SSH access.  
    ```sh
    resource "azurerm_kubernetes_cluster" "aks_cluster" {
        # ----------
        # ----------
        linux_profile {
            admin_username = "ubuntu"  # Can be parameterized using variables
            ssh_key {
                key_data = file(var.ssh_public_key)  # Path to SSH public key
            }
        }
    }
    ```
    - **`admin_username`**: Specifies the Linux admin username for the AKS nodes.  
    - **`ssh_key`**: Defines the SSH public key used for secure access to the nodes.  
    - **`key_data`**: Reads the public key from the specified file (`var.ssh_public_key`).  

- **Configuring Network Profile**  : The **network profile** defines how networking is handled in the AKS cluster.  
    ```sh
    resource "azurerm_kubernetes_cluster" "aks_cluster" {
        # ----------
        # ----------
        network_profile {
            network_plugin = "azure"  # Production-grade CNI plugin
            load_balancer_sku = "standard"  # Default load balancer type
        }
    }
    ```
    - **`network_plugin = "azure"`**:  
    - Uses Azure **CNI (Container Network Interface)** for **better scalability and security**.  
    - Recommended for **production workloads**.  
    - **`load_balancer_sku = "standard"`**:  
    - **Defaults to `standard`**, but explicitly defined for clarity.  
    - **Standard LB** provides better availability and supports more features than **Basic LB**.  

**Additional (Optional) Configurations:**  
1. **Network Policy (Optional)**  
   - Can define network security policies (e.g., `azure`, `calico`).  
   - Default is **not set** unless specified.  
2. **DNS Service and Load Balancer Settings**  
   - Can configure **outbound IPs, port allocations, and idle timeouts** under the **load balancer profile**. 
- **Further Enhancements that can be done:**  
    - Implement **custom networking (VNet/Subnets)** for fine-grained control.  
    - Define **RBAC-based access policies** for enhanced security.  
    - Enable **private cluster mode** to restrict API server access.   

- **Exporting AKS Cluster Output Values in Terraform**  : The next step is to **export key outputs** of the aks cluster to simplify cluster management.  
The following Terraform outputs will be created:  
1. **Cluster ID**  
2. **Cluster Name**  
3. **Kubernetes Version**  

```hcl
output "aks_cluster_id" {
  value = azurerm_kubernetes_cluster.aks.id
  description = "The ID of the AKS cluster."
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
  description = "The name of the AKS cluster."
}

output "aks_kubernetes_version" {
  value = azurerm_kubernetes_cluster.aks.kubernetes_version
  description = "The Kubernetes version of the AKS cluster."
}
```
- **`aks_cluster_id`** → Retrieves the **unique resource ID** of the AKS cluster.  
- **`aks_cluster_name`** → Fetches the **AKS cluster name**, useful for running `az aks get-credentials`.  
- **`aks_kubernetes_version`** → Provides the **Kubernetes version** deployed in the cluster.  
