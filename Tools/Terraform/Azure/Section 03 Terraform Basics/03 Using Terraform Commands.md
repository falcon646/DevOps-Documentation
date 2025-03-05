### **terraform init**  
Let’s start with the **terraform init** command. We will save the simple resource group terraform manifest file in a separet folder and run the 'terraform init' command there. When you run this command, it performs several tasks:  
1. **Initializing the backend**  
2. **Initializing the provider plugins**  
3. **Finding the correct version of the `HashiCorp/azurerm` provider**  
- We have defined a **version constraint** that specifies the version should be equal to **4.16.0**. This means Terraform will select the **4.16.0** version available, 
- In addition to downloading the provider, Terraform also creates a **lock file** (`.terraform.lock.hcl`) to record the selected provider versions.  

**Directory Structure After Initialization**  

- After running the `terraform init` command, you will see a few new files and folders:  
    - **`01-resourcegroup.tf`** (your Terraform configuration file)  
    - **`.terraform`** (a hidden folder created by Terraform)  
    - **`.terraform.lock.hcl`** (the lock file containing provider selections)  

- Inside the **`.terraform`** folder, there is a **`providers`** subfolder. If you navigate into the `providers` folder, you will find a path like `registry.terraform.io`.  Although you didn’t explicitly specify this path, the Terraform CLI automatically fetches providers from **`registry.terraform.io`**, which is the default API.  
    - Inside the **`registry.terraform.io`** folder, Terraform will download the **`azurerm`** provider from **HashiCorp**, using the version **4.14.0**
```bash
.
├── .terraform
│   └── providers
│       └── registry.terraform.io
│           └── hashicorp
│               └── azurerm
│                   └── 4.16.0
│                       └── windows_amd64
│                           ├── LICENSE.txt
│                           └── terraform-provider-azurerm_v4.16.0_x5.exe
├── .terraform.lock.hcl
└── 01-resourcegroup.tf
```

### **terraform validate**  
 
when we run the **Terraform validate** command .  If the configuration is valid, it will indicate success.  
```
E:\Workspace\DevOps\Tools\Terraform\Azure\Section 3 Terraform Basics\Manifest>terraform validate
Success! The configuration is valid.
```

### **terraform plan**
- when we run **Terraform plan**, Terraform generates an execution plan. This plan outlines what resources will be created in the cloud, based on the current **.tf** configuration files.  
- The plan serves as a preview of what will be created, so you can review the resources that will be deployed to your cloud account. You will have the opportunity to verify whether you're okay with the changes before proceeding.  You will see output similar to this:  
```bash
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
Terraform will perform the following actions:

# azurerm_resource_group.my_demo_rg1 will be created
+ resource "azurerm_resource_group" "my_demo_rg1" {
    + id       = (known after apply)
    + location = "eastus"
    + name     = "my_demo_rg1"
}

Plan: 1 to add, 0 to change, 0 to destroy.

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```
- In the plan, the resource to be created is named **`my_demo_rg1`** from Terraform's perspective. This is the **local reference name**, which will be explained in more detail later. The **resource group name** will be **`my-demo-rg1`**, located in **East US**.  

### **terraform apply**  
After running the `terraform plan` command, we proceed to run the **Terraform apply** command.  Terraform will prompt for confirmation before applying the changes:  

```bash
Plan: 1 to add, 0 to change, 0 to destroy.
Do you want to perform these actions? (yes/no)
```
Once you confirm by typing **yes**, Terraform will communicate with your cloud account and begin creating the resources.  

You will see the progress of the resource creation in the output:  

```bash
azurerm_resource_group.my_demo_rg1: Creating...
azurerm_resource_group.my_demo_rg1: Creation complete. Creation complete after 12s [id=/subscriptions/8a58d831-ec06-4123-aecf-cdbf9b7297ee/resourceGroups/my_demo_rg1]
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```


### **terraform destroy**

When we ran  **terraform apply**, the **terraform.tfstate** file is alos created in the same folder. This file is created automatically after running **Terraform apply** for the first time. The **terraform.tfstate** file contains crucial information about the resources you've created in the cloud, acting as a reference for Terraform to track the current state of your infrastructure.  
- In the **terraform.tfstate** file, you'll see the version , Terraform CLI version , and other metadata such as the serial number and lineage (an auto-generated value).  
- Inside the **resources** section, you'll see the reference to the resource you created, **my_demo_rg1**, which is the local name reference used in Terraform. The resource type will be listed as **azurerm_resource_group**, and other relevant metadata will be displayed.  

The **terraform.tfstate** file is important for Terraform to keep track of the resources it manages.  

When we run **terraform destroy**, Terraform will ask for confirmation before proceeding:  

```bash
Plan: 1 to destroy, 0 to add, 0 to change.
Do you want to perform these actions? (yes/no)
```

After confirming by typing **yes**, Terraform will start destroying the resources. You’ll see a message indicating that the **azurerm_resource_group** is being destroyed, followed by details such as the resource name (**my_demo_rg1**) and the action being performed.  

- After the resource is deleted, you can check the **terraform.tfstate** file again. You'll see that its size has reduced because the resources have been removed from the state file. For example, if the state file was 920 KB before, it may now be reduced to 155 KB, reflecting that no resources are listed.  
- The **terraform.tfstate** file is a **JSON file**, and it will no longer contain the resource information. If you look at the backup of the state file (stored as **terraform.tfstate.backup**), you'll find the resource information from before the destruction, as Terraform takes a backup before removing any resources.