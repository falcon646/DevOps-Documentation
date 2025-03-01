### Step-01: Create SSH Public Key for Linux VMs
```
# Create Folder
mkdir ssh-keys
cd ssh-keys

# Create SSH Key
ssh-keygen \
    -m PEM \
    -t rsa \
    -b 4096 \
    -C "azureuser@myserver" \
    -f aksprodsshkey
    -N ashwin

# List Files
ls -lrt $HOME/.ssh/aks-prod-sshkeys-terraform
```


## Step-02: Input Vairables for ssh keys in variables.tf

- SSH Public Key for Linux VMs
```
# SSH Public Key for Linux VMs
variable "ssh_public_key" {
  default = "ssh-keys/aksprodsshkey.pub"
  description = "This variable defines the SSH Public Key for Linux k8s Worker nodes"  
}
```


### Step-03: Terraform Data Sources  

> In this section, the process of using a **Terraform data source** to fetch the latest available **Azure Kubernetes Service (AKS) version** is explained. The **Terraform data source** allows fetching real-time information from Azure without manually updating values in the Terraform configuration.  


Terraform **data sources** enable retrieval of external information, which can then be used in the configuration. This avoids hardcoding values and ensures that the latest available data is always used.  
- Example : For AKS, Azure provides an API that returns the latest available versions. This API can also be accessed using the following command:  
    - This command returns all available **Kubernetes versions** for a specified Azure region, showing both **current versions** and **upgradable versions**.  
    ```sh
    az aks get-versions --location <region>
    ```
- Instead of manually updating the version in the Terraform configuration, the **Terraform data source** is used to dynamically fetch the latest version.  

- **Retrieving AKS Versions Using Terraform** 
    - Terraform provides a **data source** called `azurerm_kubernetes_service_versions`, which can be used to fetch the available Kubernetes versions.  
    - [Data Source: azurerm_kubernetes_service_versions](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_service_versions)
    - **Creating the Terraform Data Source**  : A new Terraform file is created to define the data source:  `aks-versions-data-source.tf`  
        ```
        data "azurerm_kubernetes_service_versions" "current" {
            location        = azurerm_resource_group.aks_rg.location
            include_preview = false
        }
        ```
        - **`location`**: Dynamically retrieves the **region** from the **Azure resource group** instead of hardcoding it.  
        - **`include_preview`**: Set to `false` to ensure only stable (non-preview) versions are retrieved. 
        - `include_preview` defaults to true which means we get preview version as latest version which we should not use in production. 
        - By setting `include_preview = false`, only **production-ready** versions are considered, excluding any preview versions.  
- **Defining Terraform Outputs**  Terraform outputs will be used to display the fetched AKS versions.
    - **`aks_all_versions`**: Displays all available Kubernetes versions in the specified region.  
    - **`aks_latest_version`**: Displays the latest stable Kubernetes version.  
        ```hcl
        output "aks_all_versions" {
        value = data.azurerm_kubernetes_service_versions.current.versions
        }

        output "aks_latest_version" {
        value = data.azurerm_kubernetes_service_versions.current.latest_version
        }
        ```
