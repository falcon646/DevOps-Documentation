### **Terraform Basics and Azure AKS Provisioning**

This section introduces **Terraform**, explains its purpose, and demonstrates how to use it for provisioning an **Azure Kubernetes Service (AKS) cluster**. The implementation will be divided into two parts:

1. **Section 32** – Provisioning Azure AKS using Terraform from a local desktop.
2. **Section 33** – Automating Azure AKS provisioning using **Azure DevOps CI/CD pipelines**.

### **What is Terraform?**
Terraform is an **Infrastructure as Code (IaC)** tool that allows managing cloud resources using declarative configuration files. It supports multiple cloud providers, including **Azure, AWS, and Google Cloud**.

### **Why Use Terraform for Azure AKS?**
- **Automated Infrastructure Management** – Resources are created, updated, and deleted automatically.
- **Declarative Configuration** – Uses `.tf` files to define the desired state of infrastructure.
- **Reusability** – Infrastructure definitions can be stored as reusable templates.
- **State Management** – Maintains a state file to track changes and dependencies.
- **Multi-Cloud Support** – Works across different cloud providers with minimal modifications.

---

## **Terraform Implementation for Azure AKS**
This section covers:
1. **Terraform Command Basics**
2. **Creating an Azure Resource Group**
3. **Provisioning an AKS Cluster**
4. **Configuring AKS Node Pools**
5. **Setting up AKS with a Custom VNet**

All implementations follow **real-world best practices**, ensuring a production-ready setup.

### **Terraform Directory Structure**
The Terraform configuration files (`.tf` manifests) are organized as follows:

```
terraform-manifests/
│── aks/
│   ├── main.tf             # Main Terraform configuration
│   ├── variables.tf        # Variable definitions
│   ├── resource-group.tf   # Resource group definition
│   ├── versions.tf         # Required Terraform version
│   ├── log-analytics.tf    # Log analytics workspace
│   ├── administrators.tf   # RBAC & Identity management
│   ├── ad-integration.tf   # Azure AD integration
│   ├── cluster.tf          # AKS cluster configuration
│   ├── outputs.tf          # Output values
│   ├── linux-node-pool.tf  # Linux node pool
│   ├── windows-node-pool.tf# Windows node pool
```

Each file is structured to handle specific parts of the **AKS infrastructure**, ensuring modular and manageable Terraform code.

---

## **Key Terraform Concepts Covered**
- **Terraform Commands** – Basics like `terraform init`, `plan`, `apply`, and `destroy`.
- **Variables and Outputs** – How to define and use variables (`variables.tf`) and extract useful information (`outputs.tf`).
- **Providers** – Understanding **Azure provider** and its configurations.
- **State Management** – Local vs. **Remote State Storage** (Azure Storage Account).
- **Provisioning AKS** – Creating and managing **AKS clusters, node pools, and networking**.
- **Azure Active Directory Integration** – RBAC and authentication using **Azure AD**.

---

## **Terraform State and Remote Storage**
Terraform maintains a **state file (`terraform.tfstate`)** that tracks infrastructure changes. This state can be:
- **Locally stored** (default).
- **Remotely stored in Azure** for **team collaboration and disaster recovery**.

For Azure, **remote state** is stored in an **Azure Storage Account**.

### **Remote State Configuration Example**
```hcl
terraform {
  backend "azurerm" {
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformbackend"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}
```
### **Terraform Command Basics**
This section focuses on understanding and mastering essential **Terraform commands** for day-to-day use. It covers **Terraform installation, basic commands, providers, and state management**. The goal is to provide a strong foundation in Terraform before proceeding to **Azure AKS cluster provisioning**.

---

## **1. What is Terraform?**
Terraform is an **Infrastructure as Code (IaC)** tool used to provision and manage cloud infrastructure using declarative configuration files. It supports multiple cloud providers, including:
- **AWS**
- **Azure**
- **Google Cloud**
- **Alibaba Cloud**
- **Kubernetes**
- **And many more…**

Instead of using **Azure ARM Templates** or **AWS CloudFormation**, Terraform provides a **common language** to manage resources across different cloud providers.

### **Key Features of Terraform**
1. **Infrastructure as Code (IaC)** – Infrastructure is defined in `.tf` configuration files.
2. **Multi-Cloud Support** – A single tool to manage AWS, Azure, and GCP.
3. **Declarative Configuration** – Users define the **desired state**, and Terraform ensures it.
4. **State Management** – Tracks infrastructure changes using a **state file (`terraform.tfstate`)**.
5. **Plan & Predict Changes** – The `terraform plan` command previews infrastructure changes before applying them.
6. **Modular & Reusable** – Configurations can be versioned and shared via **Terraform modules**.
7. **Remote State Storage** – Supports **Azure Storage**, **AWS S3**, or **Terraform Cloud** for collaboration.

---

## **2. Installing Terraform**
Terraform CLI is required for executing Terraform commands.

### **Installation on Windows**
1. Download the latest **Terraform binary** from [terraform.io/downloads](https://www.terraform.io/downloads).
2. Extract the ZIP file and place `terraform.exe` in a folder.
3. Add the folder to the **System PATH**:
   - Open **System Properties** → **Environment Variables** → **Path**.
   - Add the folder path containing `terraform.exe`.
4. Verify the installation:
   ```sh
   terraform version
   ```

### **Installation on Linux (Ubuntu)**
```sh
# Ensure that your system is up to date and you have installed the gnupg, software-properties-common, and curl packages installed
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
# install the HashiCorp GPG key.
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
# Verify the key's fingerprint.
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
# Add the official HashiCorp repository to your system
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
# Install Terraform from the new repository.
sudo apt update && sudo apt install terraform
terraform version
```

---

## **3. Essential Terraform Commands**
Once Terraform is installed, the following commands are commonly used:

- **Initialize Terraform** `terraform init`
    - Downloads required **Terraform providers**.
    - Sets up **Terraform backend** if configured.
    - Initializes the working directory.
- **Format Configuration Files** `terraform fmt` : Formats Terraform files (`.tf`) for readability.
- **Validate Terraform Configuration** `terraform validate` : Checks the correctness of **Terraform syntax** and provider configurations.
- **Plan Changes** `terraform plan` : Shows a **preview** of changes Terraform will make before applying them.
- **Apply Configuration** `terraform apply`
    - Creates or updates infrastructure based on `.tf` files.
    - Prompts for confirmation before applying.
- **Auto-approve Execution** `terraform apply -auto-approve` : Applies changes **without user confirmation**.
- **Destroy Resources** `terraform destroy` : Destroys all infrastructure created by Terraform.
- **Auto-approve Destruction** `terraform destroy -auto-approve` :Destroys resources **without confirmation**.
- **Show Current State** `terraform show` : Displays the current infrastructure state from the **Terraform state file**.
- **List State Resources** `terraform state list` : Lists all resources managed by Terraform in the current state.
- **Output Terraform Variables** `terraform output` : Displays values of output variables.
- **Refresh State File** `terraform refresh` : Updates the Terraform state file without modifying infrastructure.
- **Manually Store State** `terraform state push` : Manually pushes the local state to the remote backend.

---

## **4. Terraform Providers**
Terraform uses **providers** to interact with different cloud services.

### **Example: Azure Provider**
```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```
- The `azurerm` provider is required to manage **Azure resources**.
- Providers are available for **AWS, GCP, Kubernetes, MySQL, GitHub, and more**.

To view all providers, visit: [Terraform Registry](https://registry.terraform.io/browse/providers).

---

## **5. Terraform State Management**
Terraform maintains a **state file (`terraform.tfstate`)** to track resources.

### **Local State Storage (Default)**
By default, Terraform stores **state locally**:
```sh
terraform.tfstate
```

### **Remote State Storage (Azure)**
For **team collaboration**, Terraform supports **remote state storage**:
```hcl
terraform {
  backend "azurerm" {
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformbackend"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}
```
- Stores Terraform state in an **Azure Storage Account**.
- Supports **Azure Blob Storage** for reliability and access control.

---

## **6. Terraform Cloud vs. Azure DevOps**
Terraform can be executed using:
- **Terraform CLI** (local execution).
- **Terraform Cloud** (SaaS platform by HashiCorp).
- **Azure DevOps Pipelines** (Preferred for Azure users).

### **Terraform Cloud**
- Free for **up to 5 users**.
- Manages state and workflows.
- Ideal for **enterprise environments**.

### **Azure DevOps**
- Preferred by **Azure users**.
- Integrates with **Azure Repos** and **CI/CD pipelines**.
- Avoids additional costs.

Organizations can choose **Terraform Cloud or Azure DevOps** based on **business requirements**.