### **Updating an Resource**  

This section demonstrates modifying an existing **Azure Resource Group** by adding tags using Terraform.  

- **Modifying the Resource Group Configuration**  
    - Open the **`main.tf`** file.  
    - Add a new **`tags`** attribute inside the `azurerm_resource_group` resource block.  
        ```hcl
        resource "azurerm_resource_group" "example" {
            name     = "aks-rg2-tf"
            location = "East US"

            tags = {
                environment = "k8sdev"
            }
        }
        ```
    - Save the changes.  
- **Validating the Configuration**  
    - Before applying changes, validate the Terraform configuration:  
        ```sh
        terraform validate
        ```
- **Previewing Changes with `terraform plan`**  
    - Run the following command to preview the modifications:  
        ```sh
        terraform plan
        ```
    - **What happens during this step?**  
        - Terraform detects that the **tags** attribute is being added.  
        - The update is classified as **"Update in Place"**, meaning no resource deletion is required.  
        - **Example Output:**  
            ```
            Plan: 0 to add, 1 to change, 0 to destroy.
            ```
        - **Breakdown:**  
            - **`0 to add`** → No new resources will be created.  
            - **`1 to change`** → The resource will be modified in place.  
            - **`0 to destroy`** → No existing resources will be removed.  
- **Applying the Changes (`terraform apply`)**  
    - Once satisfied with the plan, execute the apply command:  
    ```sh
    terraform apply
    ```
    - Terraform generates the plan again and prompts for confirmation:  

- **Verifying the Updated Tags in Azure**  
    1. **Go to the Azure Portal** → Navigate to **Resource Groups**.  
    2. Locate the **`aks-rg2-tf`** resource group.  
    3. Click on **Tags** → The newly added tag (`environment = k8sdev`) should now be visible.  



### **Modifying a Resource Group Name in Terraform**  

This section explains the impact of modifying a **resource group name** in Terraform and how Terraform handles such changes.  

- **Understanding the Desired vs. Real State**  
    - The **Terraform configuration file (`main.tf`)** defines the **desired state** of the infrastructure.  
    - The **current state in the cloud provider** represents the **real state** of the infrastructure.  

When a resource name is modified in Terraform, it results in **resource replacement**, meaning the existing resource is destroyed and a new one is created.  

- **Modifying the Resource Group Name**  
    1. Open **`main.tf`** and locate the **`azurerm_resource_group`** block.  
    2. Change the **resource group name** from `"aks-rg2-tf"` to `"aks-rg2-tf2"`.  
- **Previewing Changes with `terraform plan`**  
  - Terraform detects a **name change**.  
  - Since **resource group names cannot be updated in place**, Terraform **destroys** the existing resource and **creates** a new one.  
  - **Output Example:**  
    ```
    -/+ destroy and then create replacement
    Plan: 1 to add, 0 to change, 1 to destroy.
    ```
  - **Breakdown:**  
    - **`1 to add`** → A new resource will be created.  
    - **`0 to change`** → No modifications to existing resources.  
    - **`1 to destroy`** → The existing resource will be deleted.  
- **Impact of Resource Replacement**  
    - **For an empty resource group:**   Since it has no resources, deleting and recreating it has no consequences.  
    - **For a resource group with critical data:**   If the resource group contains databases, persistent storage, or production workloads, **deletion may result in data loss**.  
    - Careful review of the **Terraform plan** is necessary before applying changes.  
- **Applying Changes (`terraform apply`)**   Terraform will regenerate the execution plan and prompt for 
    - **Expected Output:**  
        ```
        azurerm_resource_group.example: Destroying...
        azurerm_resource_group.example: Destruction complete.
        azurerm_resource_group.example: Creating...
        azurerm_resource_group.example: Creation complete.
        ```
- **Verifying the Changes in Azure**  
    1. **Go to the Azure Portal** → Navigate to **Resource Groups**.  
    2. Locate **`aks-rg2-tf2`** (the new resource group).  
    3. The previous resource group **`aks-rg2-tf`** should no longer exist.  