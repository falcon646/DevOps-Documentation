- **Prerequisiste-1:** If not done earlier, complete `az login` via Azure CLI. We are going to use Azure CLI Authentication for Terraform when we use Terraform Commands. 
    ```
    # Azure CLI Login
    az login --use-device-code

    # List Subscriptions
    az account list

    # Set Specific Subscription (if we have multiple subscriptions)
    az account set --subscription="SUBSCRIPTION_ID"
    ```

- **Prerequisiste-2:** Get Azure Regions and decide the region where you want to create resources
    ```
    # Get Azure Regions
    az account list-locations -o table
    ```
    - [Azure Regions](https://docs.microsoft.com/en-us/azure/virtual-machines/regions)
    - [Azure Regions Detailed](https://docs.microsoft.com/en-us/azure/best-practices-availability-paired-regions#what-are-paired-regions)



### Simple Terraform Manifest File to create a Resource Group in Azure
- Below is a simple terraform manifest file
```hcl
# settings block
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.16.0"
    }
  }
}

# provider block
provider "azurerm"{
    features{}
}

# create resoure group
resource "azurerm_resource_group" "my_demo_rg1" {
    location = "eastus"
    name = "my_demo_rg1"
}
```

The first block you see here is called the **Terraform settings block**.  In this block, core Terraform settings are defined. These include:  
- The **CLI version** to be used.  
- The **provider** to be used.  

Since we are working with **Azure Cloud**, the appropriate Azure-related provider must be configured.  To find providers, navigate to the **Terraform Registry** by visiting [registry.terraform.io](https://registry.terraform.io). Since our focus is on **Azure**, we will use the **Azure Resource Manager (azurerm) provider**, which is the official Terraform provider for Azure.  
 
- **Using the AzureRM Provider**  
To use this provider, the configuration block can be copied from the Terraform Registry and added to the Terraform settings block:  
    ```hcl
    terraform {
        required_providers {
            azurerm = {
            source  = "hashicorp/azurerm"
            version = "4.16.0"
            }
        }
    }
    ```
    - The provider name is **azurerm**.  
    - The **source** is `"hashicorp/azurerm"`, indicating that it is an official HashiCorp provider. By default, Terraform retrieves the provider from `registry.terraform.io`, so specifying the URL explicitly is not necessary. 
    - The **version** is set to `"4.16.0"`, which is optional but recommended for production to avoid unexpected updates.  


The following is the **provider block**. In this configuration, The provider is **azurerm** & the `features {}` block is required but can be left empty for basic configurations.  
```hcl
provider "azurerm" {
  features {}
}
```
**Defining a Resource in Terraform**  : After configuring the provider, the next step is to define resources. Below is a simple example of creating an **Azure Resource Group** using Terraform:  

```hcl
resource "azurerm_resource_group" "my_demo_rg1" {
  location = "eastus"
  name     = "my_demo_rg1"
}
```
- The **resource type** is `azurerm_resource_group`, which is used to create a resource group in Azure.  
- `"my_demo_rg1"` is the **local name reference**, which will be explained in detail in upcoming sections.  
- The **location** is set to `"eastus"`, meaning the resource group will be created in the East US Azure region.  
- The **name** is `"my_demo_rg1"`, which will be the name of the resource group in Azure.  
