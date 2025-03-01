### **Terraform Plan, Apply, and Creating an Azure Resource Group**  

This section explains how to use **`terraform plan`** and **`terraform apply`** to provision an **Azure Resource Group** using Terraform.  

- **Prerequisites**  
    - **Authentication**: Ensure that authentication with Azure is configured.  The user should be logged in via **Azure CLI** (`az login`) or another authentication method.  


- **Updating `main.tf` in the**  
    - Navigate to the `masnifesrt` folder where Terraform configurations will be written.
    - Define the **provider block** and the **resource block** for the Azure Resource Group in the `main.tf`.


#### **Understanding the Resource Block**  
A **resource block** in Terraform defines the infrastructure to be provisioned.  

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "aks_rg2" {
  name     = "AKS-RG2-TF"
  location = "East US"
}
```

| **Component** | **Description** |
|--------------|---------------|
| `resource "azurerm_resource_group"` | Defines an **Azure Resource Group**. |
| `"example_rg"` | A **user-defined name** used only within Terraform for referencing this resource. |
| `name = "AKS-RG2-TF"` | The **actual name** of the resource group created in Azure. |
| `location = "East US"` | Specifies the Azure region where the resource group will be deployed. |


- **Executing Terraform Configuration**  
    - **1. Initializing Terraform**
        ```sh
        terraform init
        ```
        - Downloads the required provider plugins.
        - Creates a `.terraform` directory for dependencies.

    - **2. Running `terraform plan`**
        ```sh
        terraform plan
        ```
        - Validates the configuration and outputs the execution plan.  
        - Displays any changes Terraform will make.  
        - Example output:
        ```
        Plan: 1 to add, 0 to change, 0 to destroy.
        ```
    - **3. Applying the Terraform Configuration**
        ```sh
        terraform apply
        ```
        - Prompts for confirmation before creating resources.
        - After confirmation, Terraform provisions the resource.
        - Example output:
        ```
        Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
        ```


### **Terraform State Management (`terraform.tfstate`)**  
- After applying changes, Terraform updates the **state file (`terraform.tfstate`)**.  
- This file maintains the mapping between Terraform resources and actual infrastructure.  
- The state file includes:
  - **Resource type:** `azurerm_resource_group`
  - **User-defined name:** `AKS_RG2`
  - **Actual resource name:** `AKS-RG2-TF`
  - **Provider details:** `AzureRM`
  - **Resource ID (generated after apply)**