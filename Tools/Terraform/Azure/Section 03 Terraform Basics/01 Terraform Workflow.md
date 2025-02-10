##  Introduction
It is essential to understand the Terraform command workflow and the commands that form the basic Terraform workflow.
- There are five key commands that play a crucial role in the overall Terraform workflow
    - **Terraform init**  
    - **Terraform validate**  
    - **Terraform plan**  
    - **Terraform apply**  
    - **Terraform destroy**   


- **Terraform init**   : The `terraform init` command initializes a working directory containing Terraform configuration files. It is the first command that should be executed after writing a new Terraform configuration. This command downloads the required provider(s) as specified in the configuration.  

- **Terraform validate**  : The `terraform validate` command checks the syntax and internal consistency of the Terraform configuration files in the working directory. It ensures that the configuration is structurally correct before applying any changes.  

- **Terraform plan**  : The `terraform plan` command generates an execution plan by performing a refresh and determining the necessary actions to reach the desired state as defined in the Terraform configuration files. This step helps preview the changes Terraform will make before applying them.  

- **Terraform apply**  : The `terraform apply` command provisions resources on the specified cloud provider as defined in the `.tf` files. When this command is executed, Terraform creates the resources according to the configuration.  

- **Terraform destroy**  : The `terraform destroy` command removes the Terraform-managed infrastructure. While `terraform apply` is used to create resources, `terraform destroy` deletes them.  Both the `terraform apply` and `terraform destroy` commands prompt for confirmation before executing their respective actions.  
  

[![Image](https://stacksimplify.com/course-images/azure-terraform-workflow-1.png "HashiCorp Certified: Terraform Associate on Azure")](https://stacksimplify.com/course-images/azure-terraform-workflow-1.png)

[![Image](https://stacksimplify.com/course-images/azure-terraform-workflow-2.png "HashiCorp Certified: Terraform Associate on Azure")](https://stacksimplify.com/course-images/azure-terraform-workflow-2.png)

## Review terraform manifests
- **Pre-Conditions-1:** Get Azure Regions and decide the region where you want to create resources
```t
# Get Azure Regions
az account list-locations -o table
```
- **Pre-Conditions-2:** If not done earlier, complete `az login` via Azure CLI. We are going to use Azure CLI Authentication for Terraform when we use Terraform Commands. 
```t
# Azure CLI Login
az login

# List Subscriptions
az account list

# Set Specific Subscription (if we have multiple subscriptions)
az account set --subscription="SUBSCRIPTION_ID"
```
- [Azure Regions](https://docs.microsoft.com/en-us/azure/virtual-machines/regions)
- [Azure Regions Detailed](https://docs.microsoft.com/en-us/azure/best-practices-availability-paired-regions#what-are-paired-regions)
      
 



