### **Configuring the Default Node Pool in an AKS Cluster using Terraform**  

In this section, the **default node pool** for the AKS cluster is configured. This block is present inside the `azurerm_kubernetes_cluster ` resource block . The key parameters include: 

```sh
resource "azurerm_kubernetes_cluster" "aks_cluster" {
    # ----------
    # ----------
    default_node_pool {
        name       = "systempool"
        node_count = 1
        vm_size    = "Standard_DS2_v2"
        zones      = [1, 2, 3]  
        auto_scaling_enabled = true
        orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
        max_count = 3
        min_count = 1
        os_disk_size_gb = 30
        type = "VirtualMachineScaleSets"
        node_labels = {
            "nodepool-type" = "system"
            "environment"   = "dev"
            "nodepoolos"    = "linux"
            "app"           = "system-apps"
            }
        tags = {
            "nodepool-type" = "system"
            "environment"   = "dev"
            "nodepoolos"    = "linux"
            "app"           = "system-apps"
            }
        }
    }
```
- **Node Pool Name**: Set to `"systempool"` to indicate it is the **system node pool**.  
- **Node Count**: Initially set to `1`. However, since **auto-scaling** is enabled, this value is optional.  
- **VM Size**: The **size of the VM** for the worker nodes is set to `"Standard_DS2_v2"`.  
- **Availability Zones**: The nodes are distributed across **three availability zones** for high availability (`[1, 2, 3]`).  
- **Auto Scaling**:  
  - **Enabled (`true`)** to allow Kubernetes to scale the number of nodes based on workload demand.  
  - **Min Count**: `1` (minimum number of nodes).  
  - **Max Count**: `3` (maximum number of nodes).  
- **OS Disk Size**:  
  - Set to `30GB`.  
  - This is the **storage space** allocated for each node.  
- **Virtual Machine Scale Sets (VMSS)**:  **Enabled (`type = "VirtualMachineScaleSets"`)** for better scalability and reliability.  
- **Node Labels** are used to:  
    - Identify the **node pool type** (e.g., `"system"`).  
    - Set the **environment** (e.g., `"dev"`).  
    - Define the **OS type** (e.g., `"linux"`).  
    - Tag the **workloads** running on this node pool (e.g., `"system-apps"`).  
- **Tags** serve a similar purpose but are used for **resource tracking** within Azure.  


### **Configuring Identity, Monitoring, and Azure AD RBAC in an AKS Cluster using Terraform**  

This section covers configuring:  
1. **Identity Management**  
2. **Monitoring with OMS Agent**  
3. **Azure AD Role-Based Access Control (RBAC)**  

- **Configuring System-Assigned Identity**   : Azure Kubernetes Service (AKS) supports **two types of identities**:  
    - **System-Assigned Identity** (default)  
    - **Service Principal**  
    - For this setup, **system-assigned identity** is used, which allows the AKS cluster to authenticate against Azure services securely.  
        ```sh
        resource "azurerm_kubernetes_cluster" "aks_cluster" {
            # ----------
            # ----------
            identity {
            type = "SystemAssigned"
            }
        }
        ```
    - **System-Assigned Identity** is tied directly to the AKS resource.  
        - Azure manages its lifecycle automatically.  
        - It eliminates the need for storing credentials like a **Service Principal**.  

- **Enabling Monitoring with OMS Agent**   : Monitoring is **essential** for tracking cluster health and performance. The **OMS (Operations Management Suite) Agent** integrates AKS with **Azure Monitor** by sending logs and metrics to **Azure Log Analytics**.  
    - **OMS Agent** collects logs and container metrics.  
    - Logs are stored in **Azure Log Analytics Workspace** (`azurerm_log_analytics_workspace`).  
    - The **workspace ID** is referenced to link AKS with **Azure Monitor**.  
        ```sh
        resource "azurerm_kubernetes_cluster" "aks_cluster" {
            # ----------
            # ----------
            oms_agent {
                log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
            }
        }
        ```
- **Enabling Azure AD Role-Based Access Control (RBAC)**  : To improve security, **Azure AD-based RBAC** is enabled instead of the **default Kubernetes-native RBAC**. 
    - This block is  is used to enable **Azure Active Directory (Azure AD) Role-Based Access Control (RBAC)** for the AKS cluster. 
        ```sh
        resource "azurerm_kubernetes_cluster" "aks_cluster" {
            # ----------
            # ----------
            azure_active_directory_role_based_access_control {
                admin_group_object_ids = [azuread_group.aks_administrators.id]
            }
        }
        ```
    - **`azure_active_directory_role_based_access_control`**   : This block is used to integrate Azure AD with AKS, allowing authentication to the Kubernetes API using Azure AD identities instead of Kubernetes-native service accounts.
    - **`admin_group_object_ids = [azuread_group.aks_administrators.id]`**  :This defines a list of **Azure AD group object IDs** that will have **Kubernetes administrator privileges** in the AKS cluster.  
        - `azuread_group.aks_administrators.id` refers to a pre-defined Azure AD group (which is created using the `azuread_group` resource in Terraform).  
        - Members of this group will have admin access to the Kubernetes cluster through **RBAC**.
    - **Why is This Important?**
        - This setup ensures that **only users in the specified Azure AD group can manage the AKS cluster**.  
        - It enforces **centralized identity and access management** using Azure AD instead of Kubernetes-native RBAC, which improves security and simplifies access management.  

- **Outputting Azure AD Group Information**  

To verify the Azure AD integration, output values for the **Azure AD group ID** can be defined:  

```hcl
# Output Azure AD Group ID
output "azure_ad_group_id" {
  value = azuread_group.aks_administrators.id
}

# Output Azure AD Group Object ID
output "azure_ad_group_objectid" {
  value = azuread_group.aks_administrators.object_id
}
```

- **`azure_ad_group_id`**: The **Azure AD Group ID** used for RBAC.  
- **`azure_ad_group_objectid`**: The **Azure AD Group Object ID**, which may be referenced in documentation.  


