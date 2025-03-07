# Understanding terraform show, terraform providers, and terraform destroy
This section explains three essential Terraform commands:

- `terraform show` – To inspect Terraform state and resources.
- `terraform providers` – To list providers used in a Terraform project.
- `terraform destroy` – To delete resources created using Terraform.


### Terraform Show  
- The `terraform show` command is used to inspect the Terraform state or plan. Executing `terraform show` will display details of all the resources managed by Terraform.  
- This command outputs details of the resources Terraform has created. Instead of manually browsing through state files, `terraform show` provides a structured view of the infrastructure.  
    - Displays the current Terraform state by retrieving details from the `terraform.tfstate` file.
    - Useful for checking which resources exist and their properties without browsing the state file manually.

### Terraform Providers  
- The `terraform providers` command prints a tree of providers used in the Terraform configuration files. It -displays:  
    - The providers required by the configuration.  
    - The providers stored in the state file, showing which providers Terraform is currently using. 
    - Shows which providers are referenced in .tf files and which ones are actually being used in terraform.tfstate. 
        - For example, if the `azurerm` provider is used for managing Azure resources, it will appear in the output as the provider required by the configuration.  
        ```sh
        Providers required by configuration:
        - provider["registry.terraform.io/hashicorp/azurerm"] 

        Providers required by state:
        - provider["registry.terraform.io/hashicorp/azurerm"]
        ```  

### Terraform Destroy  
The `terraform destroy` command is used to delete resources created by Terraform. By default, running `terraform destroy` removes all resources defined in the state file.  
- To destroy all resources:  `terraform destroy`
- to delete a specific resource, use the `-target` flag:  `terraform destroy -target <resource_type>.<resource_name>`
    - For example, if a specific resource named `my_instance` of type `aws_instance` needs to be deleted:  `terraform destroy -target aws_instance.my_instance`
    - Terraform will prompt for confirmation before proceeding with the deletion. If confirmed, only the specified resource will be removed, while others remain intact.  