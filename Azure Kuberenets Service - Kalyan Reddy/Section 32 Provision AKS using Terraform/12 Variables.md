##  Understand and Create Terraform Input Variables
- Three types of Terraform Variables
    - [Input Variables](https://www.terraform.io/docs/configuration/variables.html)
    - [Output Values](https://www.terraform.io/docs/configuration/outputs.html)
    - [Local Values](https://www.terraform.io/docs/configuration/locals.html)
This lecture will primarily focus on **input variables**.  

### Input Variables
Input variables allow Terraform deployments to be parameterized, making it possible to reuse the same Terraform project for multiple environments such as **development (dev), quality assurance (QA), staging, and production**.  
- We can parameterize our deployments using Terraform Input Variables.
- This is the right way to build a Terraform project that can be reused to deploy multiple environments like dev, qa, staging and production
- Implementing Input Variables for an AKS Cluster  
    - To understand the different ways to pass input variables, various available options will be explored. In practice, the **`variables.tf`** file will be used to define input variables for the project. However, additional methods will also be covered, including:  
        - Passing input variables at runtime using the **`-var`** flag  
        - Using the **`-var-file`** flag for structured variable definitions  

**Defining Terraform Variable and Resource Group**

- Prior to defining the variable, we'll create a simple **resource group** without using variables. 
    ```hcl
    resource "azurerm_resource_group" "aka_rg" {
        name     = "Terraform_AKS"
        location = "Central US"
    }
    ```
- Now to variablise the values we provied above , we'll create a variable,tf file to declare our variables
    ```hcl
    # Azure Location
    variable "location" {
        type = string
        description = "Azure Region where all these resources will be provisioned"
        default = "Central US"

    }

    # Azure Resource Group Name
    variable "resource_group_name" {
    type = string
    description = "This variable defines the Resource Group"
    default = "terraform-aks"
    }

    # Azure AKS Environment Name
    variable "environment" {
    type = string  
    description = "This variable defines the Environment"  
    default = "dev"
    }
    ```
    - Now , we refer these valus in the resouyrces block
    ```hcl
    resource "azurerm_resource_group" "aks_rg" {
        name = "${var.resource_group_name}-${var.environment}"
        location = var.location
    }
    ```