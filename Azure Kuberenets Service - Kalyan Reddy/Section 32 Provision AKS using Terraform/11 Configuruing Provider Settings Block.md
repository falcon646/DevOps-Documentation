### **Implementing Terraform Providers and Settings Block**  
Navigate to the **manifests** folder. Inside this folder, there are **four files** that contain structured definitions of what we will implement. These files are organized to provide **clear visibility** into each configuration step.  

In this section, we will focus on completing the below setting on the `main.tf`:  

The **Terraform settings block**, which includes:  
-  **Terraform required version**  
    - for `azurerm` , `azuread` and `random` provider
- **Terraform providers**  
    - The **Terraform provider block** for **Azure Resource Manager (azurerm)**, which includes the **features block**
    - The **Terraform resource block** for a **random pet resource**.  

```sh
# 1. Terraform Settings Block
terraform {
    required_version = ">=1.0.0"
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = ">=4.0"
        }
        random = {
            source = "hashicorp/random"
            version = "3.6.3"
        }
        azuread = {
            source  = "hashicorp/azuread"
            version = "~> 3.0"
        }
    }
}

# 2. Terraform Provider Block for AzureRM
provider "azurerm" {
  subscription_id = "XXXXXXXX"
  features {
  }
}

# 3. Terraform Resource Block: Define a Random Pet Resource
resource "random_pet" "aksrandom" {

}
```