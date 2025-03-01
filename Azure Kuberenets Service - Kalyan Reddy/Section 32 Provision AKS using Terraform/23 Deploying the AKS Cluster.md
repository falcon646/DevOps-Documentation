### **Terraform Backend Initialization and AKS Deployment**  

This section describes the process of **initializing Terraform**, configuring the **backend state file**, and executing Terraform commands to deploy an **Azure Kubernetes Service (AKS) cluster**.  


#### **Step 1: Terraform Initialization**  

Run the following command to initialize Terraform:  
```sh
terraform init
```
This command downloads required **providers** and initializes the **Terraform state backend**.  
If needed, the state file name can be customized. For example, for a **Dev environment**, update `main.tf` to define the state file as:  
```hcl
backend "azurerm" {
  container_name = "tfstate"
  key            = "dev.terraform.tfstate"
}
```
After modifying the configuration, re-run `terraform init` to apply changes.

#### **Step 2: Terraform Plan and State Validation**  

To validate the configuration, use:  
```sh
terraform validate
```
Once validated, run:  

```sh
terraform plan
```
This command previews the **resources** that Terraform will create. At this stage, the **Terraform state file** (`dev.terraform.tfstate`) will be generated and locked to prevent concurrent modifications. The lock will be released after execution.
To save the plan output for later execution, use:  

```sh
terraform plan -out=v1.plan.out
```

#### **Step 3: Terraform Apply**  
To apply the planned changes, run:  

```sh
terraform apply v1.plan.out
```
Terraform will:  
- Create **Azure Kubernetes Service (AKS) resources**  
- Configure **Azure Active Directory (AAD) integration**  
- Set up **networking and load balancing**  
- Enable **Autoscaler, RBAC, and Log Analytics Workspace**  

The state file (`dev.terraform.tfstate`) will be updated with the created resources.


#### **Step 4: Resource Naming and Environment-Specific Configurations**  
Terraform appends the **environment name** (`dev`, `qa`, etc.) to the **resource group** and **AKS cluster name** to maintain isolation.  
For example, in a **Dev environment**, the AKS cluster name follows this format:  
```
terraform-aks-dev-cluster
```
For a **QA environment**, change the backend state file name:  

```sh
terraform plan -out=qa.plan.out
```
Then, execute:  
```sh
terraform apply qa.plan.out
```
This ensures separate **Terraform state files** for each environment.  

#### **Step 5: Verifying Deployment**  
After the deployment, the **AKS cluster** will take **3-5 minutes** to be fully provisioned. To verify:  
```sh
az aks show --resource-group terraform-aks-dev --name terraform-aks-dev-cluster
```
Once the cluster is ready, credentials can be retrieved using:  

```sh
az aks get-credentials --resource-group terraform-aks-dev --name terraform-aks-dev-cluster
```