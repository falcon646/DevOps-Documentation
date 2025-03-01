
### Understanding Terraform Output Values  
Output values in Terraform function as the return values of a Terraform module. They provide a way to expose information from a module to the user.  

These output values can be used:  
1. Between **child and parent modules**  
2. Within the **root module** to expose information to the terminal during `terraform apply`  
3. To **exchange data** between multiple child modules and a root module  

By using output values, useful resource information can be displayed on the command line or shared between modules.  

For the current use case, output values will primarily be used to retrieve the **AKS cluster name** and **resource group name**, which are needed for constructing the `az aks get-credentials` command.  

- Generallly an `outputs.tf` file will be created to store output values. 
- In out example here ,  Three output values will be created:  
    1. **Location**  
    2. **Resource Group ID**  
    3. **Resource Group Name**  
- **Defining an Output Value  **
    - To define an output value, use the `output` block.  For example, to output the **location** of the resource group:  
        ```hcl
        output "location" {
            value = azurerm_resource_group.example.location
        }
        ```
        - The `output` block is named `"location"`.  
        - The `value` field references the location of the created resource group.  

    - Similarly, to define an output for the **resource group ID** and **name**:  
        ```hcl
        output "resource_group_id" {
            value = azurerm_resource_group.example.id
        }
        output "resource_group_name" {
            value = azurerm_resource_group.example.name
        }
        ```
        - The `id` attribute is used to retrieve the resource group ID.  