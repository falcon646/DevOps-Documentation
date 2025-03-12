### **Managing Multiple Environments in Terraform (Without Workspaces)**  

Since you don't want to use Terraform **workspaces**, the best way to manage multiple environments (`dev`, `test`, `stage`, `prod`) is by **using separate directories, backend configurations, and variable files**.  

---

## **1. Use Separate Directories for Each Environment**  
A **directory-based structure** ensures complete isolation between environments.

```
terraform/
├── dev/
│   ├── main.tf
│   ├── variables.tf
│   ├── backend.tf
│   ├── terraform.tfvars
├── stage/
│   ├── main.tf
│   ├── variables.tf
│   ├── backend.tf
│   ├── terraform.tfvars
├── prod/
│   ├── main.tf
│   ├── variables.tf
│   ├── backend.tf
│   ├── terraform.tfvars
```
- Each environment has **its own Terraform state file**.
- You can use **different cloud resources, settings, and configurations per environment**.

---

## **2. Use Backend Configuration per Environment**  
Each environment should have **its own backend storage** to manage Terraform state separately.

#### **Example: `backend.tf` for Each Environment**  
For **AWS S3 backend**:
```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "env/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
```
For **Azure Storage Account backend**:
```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-backend"
    storage_account_name = "terraformstatestorage"
    container_name       = "terraform-state-dev"
    key                 = "terraform.tfstate"
  }
}
```

---

## **3. Use Separate Variable Files (`terraform.tfvars`)**  
Each environment should have **its own variable file**.

#### **Example: `terraform.tfvars` per environment**
**`dev/terraform.tfvars`**
```hcl
instance_type = "t3.micro"
environment   = "dev"
```
**`prod/terraform.tfvars`**
```hcl
instance_type = "t3.large"
environment   = "prod"
```
### **How to Apply the Right Variables**
Use the `-var-file` flag when applying Terraform:
```sh
terraform apply -var-file="dev/terraform.tfvars"
terraform apply -var-file="prod/terraform.tfvars"
```

---

## **4. Use a Common Module for Reusability**  
Instead of duplicating Terraform code, create a **modules/** directory to store reusable components.

```
terraform/
├── modules/
│   ├── compute/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── networking/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
├── dev/
│   ├── main.tf
│   ├── variables.tf
│   ├── backend.tf
│   ├── terraform.tfvars
├── prod/
│   ├── main.tf
│   ├── variables.tf
│   ├── backend.tf
│   ├── terraform.tfvars
```
Each environment **calls the common modules** instead of duplicating Terraform code.

**Example: `dev/main.tf`**
```hcl
module "networking" {
  source      = "../modules/networking"
  vpc_cidr    = "10.0.0.0/16"
}

module "compute" {
  source        = "../modules/compute"
  instance_type = "t3.micro"
  environment   = "dev"
}
```

---

## **5. Use `TF_VAR` Environment Variables (Optional)**
If you don’t want separate `terraform.tfvars` files, use **environment variables** to manage configurations dynamically.

```sh
export TF_VAR_instance_type="t3.micro"
export TF_VAR_environment="dev"

terraform apply
```

---

## **Best Practices for Multi-Environment Terraform**
| **Strategy** | **Pros** | **Cons** |
|-------------|---------|---------|
| Separate directories (`dev/`, `prod/`) | Complete isolation, no state conflicts | More complex file management |
| Separate backend configurations | Ensures different states for environments | Requires manual backend setup |
| Using `-var-file` with `terraform.tfvars` | Simpler than directories | Less strict isolation |
| Modular approach (`modules/`) | Code reusability | Requires good module design |
| Environment variables (`TF_VAR_`) | Dynamic and flexible | Can be hard to track values |

---

## **Conclusion**
To manage multiple environments in Terraform **without workspaces**:
1. **Use separate directories** for each environment.
2. **Define different backend configurations** to store state files separately.
3. **Use `terraform.tfvars` files** to define environment-specific values.
4. **Leverage modules** to reuse Terraform configurations.
5. **Use environment variables (`TF_VAR_`)** as an alternative.

This approach ensures **better isolation, flexibility, and maintainability**. Let me know if you need a customized example for your setup!