## **Provisioning an AKS Cluster**

To do this, we need to review the documentation related to the **Azure RM Kubernetes Cluster** resource. This Terraform template will be extensive, as we will incorporate all necessary configurations required for a fully functional AKS cluster.  

We will now write the complete Terraform manifest for the **AKS cluster**. To provision an AKS cluster, several key configurations are required. While a minimal setup can work, we will take a comprehensive approach to ensure all essential settings are covered.  

**Configurations Covered in the AKS Terraform Template**  

1. **Basic Cluster Settings**  
   - Define the **Kubernetes version** using the **Kubernetes version data source**.  
   - Configure the **node resource group**.  

2. **Default Node Pool Configuration**  
   - Set the **orchestration version** using the **latest Kubernetes version**.  
   - Specify **availability zones** for high availability.  
   - Enable **auto-scaling**, defining the **minimum and maximum node count**.  
   - Configure **disk size**, **node type**, **node labels**, and **tags**.  

3. **Identity Management**  
   - Use **Managed Identity (MSI)** instead of **Service Principals** for authentication.  

4. **Monitoring & Logging**  
   - Enable the **monitweing** with **Log Analytics Workspace ID**.  

5. **Access Control**  
   - Configure **RBAC integration**.  
   - Define **admin profiles**.  
   - Configure **Windows and Linux user profiles**, including **username and password**.  

6. **Networking**  
   - Set the **network profile**.  

7. **Cluster Metadata**  
   - Apply **tags** for better organization and tracking.  

### Step-06: AKS Cluster Configuration**  `aks-cluster.tf` 

Before making modifications, we need to start with a base resource block. The `azurerm_kubernetes_cluster` is used in Terraform to provision an AKS cluster.

A key consideration when using Terraform for AKS provisioning is that client secrets (if used) will be stored in plaintext in the Terraform state file. This is a security drawback when managing sensitive credentials, so using Managed Identities is a recommended alternative.

Now, let's extract the base configuration from the Terraform documentation.  

```hcl
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "${azurerm_resource_group.aks_rg.name}-aks-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "${azurerm_resource_group.aks_rg.name}-aks-cluster"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${azurerm_resource_group.aks_rg.name}-node-rg"
}
```
- Understanding the Key Parameters**  
    - **Cluster Name**: The cluster name is derived from the **resource group name**, ensuring consistency.  
    - **Resource Group Name**: The cluster will be deployed in the resource group defined earlier.  
    - **Location**: This will be the same as the resource group location.  
    - **DNS Prefix**: The **DNS prefix** follows the cluster name pattern for uniformity.  
    - **Kubernetes Version**: This is dynamically fetched using the **azurerm_kubernetes_service_versions** data source.  
    - **Node Resource Group**:  
        - By default, AKS creates a **managed resource group** prefixed with `MC_<cluster-name>_<resource-group>`.  
        - However, defining the **node resource group explicitly** ensures a structured naming convention.  
        - The node resource group will follow the pattern:  `<resource-group-name>-node-rg`
        - This helps in organizing **aks-cluster resources** like virtual networks, load balancers, and storage accounts.
