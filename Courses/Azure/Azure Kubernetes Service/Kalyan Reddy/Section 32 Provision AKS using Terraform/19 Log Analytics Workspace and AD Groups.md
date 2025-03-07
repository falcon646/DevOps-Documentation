## Creating an Azure Log Analytics Workspace and Azure AD AKS Admins Using Terraform  

This section describes how to define Terraform resources for:  

1. **Azure Log Analytics Workspace** – Required for monitoring AKS clusters using Azure Monitor.  
2. **Azure AD AKS Admins** – Used to configure Azure Active Directory authentication for AKS clusters.  

### Step-04: Azure Log Analytics Workspace in Terraform

The **Log Analytics Workspace** is essential for **Azure Monitor for Containers** (also known as **Container Insights**) to track and analyze container performance in an **Azure Kubernetes Cluster (AKS)**.  

- **Defining the Log Analytics Workspace Resource**  `log-analytics-workspace.tf`  
    ```hcl
    resource "azurerm_log_analytics_workspace" "insights" {
    name                = "log-insights-${random_string.suffix.result}"
    location            = azurerm_resource_group.aks_rg.location
    resource_group_name = azurerm_resource_group.aks_rg.name
    sku                 = "PerGB2018"
    retention_in_days   = 30
    }
    ```
    - **`name`**: A unique name is required across Azure, so a **random string** is appended.  
    - **`location`**: Dynamically retrieved from the resource group.  
    - **`resource_group_name`**: Ensures the workspace is created in the correct resource group.  
    - **`sku`**: The pricing tier for the workspace (`PerGB2018` is the default).  
    - **`retention_in_days`**: Specifies how long logs are retained (default is 30 days).  


### Step-05: Azure AD AKS Admins Configuration**  `aks-ad-admins.tf`  
Azure AD integration enables **Role-Based Access Control (RBAC)** for **Azure Kubernetes Service (AKS)**.  
- To enable **Azure AD integration** with AKS, an **Azure AD group object ID** must be provided to the Azure AKS cluster. This allows AKS to map the **AKS administrator group** to the Azure AD group, ensuring that users within this group can administer the AKS cluster.  
    ```hcl
    resource "azuread_group" "aks_admins" {
    display_name     = "${azurerm_resource_group.aks_rg.name}-cluster-administrators"
    security_enabled = true
    description      = "Group for AKS cluster administrators"
    }
    ```
    - This Terraform configuration creates an **Azure AD group** with the following properties:  
        - **`display_name`**: The name of the group is dynamically generated using the **resource group name**, followed by `-cluster-administrators`.  
        - **`security_enabled`**: Ensures that the group is security-enabled.  
        - **`description`**: Provides a brief description of the group’s purpose.  
