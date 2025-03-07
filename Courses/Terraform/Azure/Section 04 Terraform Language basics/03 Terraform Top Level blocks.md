
# **Terraform Top-Level Blocks**

Terraform configurations consist of **top-level blocks**, which define the structure and behavior of infrastructure-as-code. These blocks exist **outside of any other block** in Terraform configuration files.

Terraform provides **eight core top-level blocks**
1. Terraform Settings Block
2. Provider Block
3. Resource Block
4. Input Variables Block
5. Output Values Block
6. Local Values Block
7. Data Sources Block
8. Modules Block


These can be categorized into three groups:


1. **Fundamental Blocks** – Define Terraform settings, provider configurations, and resource creation.
2. **Variable Blocks** – Handle input variables, output values, and local values.
3. **Calling/Referencing Blocks** – Enable data retrieval and modularization.


### **1. Fundamental Blocks**
These are the essential blocks required to configure Terraform and define cloud resources.

#### **(a) `terraform` Block – Terraform Settings**
The `terraform` block is used to specify **Terraform settings**, such as required versions and backend configurations.
**Example**
```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateaccount"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
```
- **Key Features**:
    - **`required_version`**: Specifies the minimum Terraform version.
    - **`required_providers`**: Defines provider dependencies and versions.
    - **`backend`**: Configures remote state storage.

#### **(b) `provider` Block – Cloud Provider Configuration**
The `provider` block configures settings for the cloud provider (e.g., AWS, Azure, GCP).
**Example (Azure Provider)**
```hcl
provider "azurerm" {
  features {}
  subscription_id = "YOUR_SUBSCRIPTION_ID"
}
```
- **Key Features**:
    - Specifies the provider (`azurerm` for Azure).
    - Configures provider-specific settings.

#### **(c) `resource` Block – Define Infrastructure Resources**
The `resource` block is used to create **infrastructure resources** like virtual machines, networks, and storage.
**Example (Creating an Azure Resource Group)**
```hcl
resource "azurerm_resource_group" "example" {
  name     = "myResourceGroup"
  location = "East US"
}
```
- **Key Features**:
    - Defines **resource type** (`azurerm_resource_group`).
    - Assigns a **logical name** (`example`).
    - Specifies **configuration parameters**.


### **2. Variable Blocks**
These blocks manage input values, output values, and locally scoped variables.

#### **(a) `variable` Block – Define Input Variables**
The `variable` block allows defining reusable input parameters.
**Example**
```hcl
variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}
```
- **Key Features**:
    - Defines a **variable name** (`location`).
    - Specifies **data type** (`string`).
    - Sets an optional **default value**.

#### **(b) `output` Block – Define Output Values**
The `output` block is used to **return values** after resource creation.

**Example**
```hcl
output "resource_group_name" {
  description = "The name of the created resource group"
  value       = azurerm_resource_group.example.name
}
```
- **Key Features**:
    - Defines **output name** (`resource_group_name`).
    - Returns a **resource attribute** (`azurerm_resource_group.example.name`).

#### **(c) `locals` Block – Define Local Variables**
The `locals` block allows defining temporary variables within a module.
**Example**
```hcl
locals {
  prefix = "myproject"
}

resource "azurerm_resource_group" "example" {
  name     = "${local.prefix}-rg"
  location = "East US"
}
```
- **Key Features**:
    - Defines a **local variable** (`prefix`).
    - Helps in **reducing repetition** in configurations.

### **3. Calling and Referencing Blocks**
These blocks help in **retrieving data from external sources** and **modularizing** Terraform configurations.

#### **(a) `data` Block – Fetch Existing Resources**
The `data` block is used to **query and retrieve information** about existing resources.
**Example (Fetching an Existing Resource Group)**
```hcl
data "azurerm_resource_group" "existing" {
  name = "myResourceGroup"
}

output "resource_group_location" {
  value = data.azurerm_resource_group.existing.location
}
```
- **Key Features**:
    - Retrieves **pre-existing** cloud resources.
    - Uses **output values** to extract properties.

#### **(b) `module` Block – Reusing Terraform Configurations**
The `module` block is used to **import and reuse** Terraform code.

**Example (Calling a Network Module)**
```hcl
module "network" {
  source = "./modules/network"
  vnet_name = "myVNet"
}
```
- **Key Features**:
    - Calls a **predefined module** (`network`).
    - Passes **input variables** (`vnet_name`).
---
## **Summary**

| **Block**       | **Purpose** |
|---------------|------------|
| `terraform`  | Configures Terraform settings, provider versions, and backends. |
| `provider`   | Defines provider-specific settings (e.g., Azure, AWS). |
| `resource`   | Creates cloud resources (e.g., VMs, networks, storage). |
| `variable`   | Defines input parameters for Terraform configurations. |
| `output`     | Returns values after execution (e.g., resource IDs, names). |
| `locals`     | Stores reusable variables for temporary use within a module. |
| `data`       | Retrieves existing resources from the cloud provider. |
| `module`     | Calls external Terraform modules for code reuse. |

