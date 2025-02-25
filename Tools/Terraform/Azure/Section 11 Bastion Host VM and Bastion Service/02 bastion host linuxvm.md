
## ntroduction
- We are going to create two important Bastion Resources 
    - Azure Bastion Host 
    - Azure Bastion Service 

- We are going to use following Azure Resources for the same.
1. Terraform Input Variables
2. azurerm_public_ip
3. azurerm_network_interface
4. azurerm_linux_virtual_machine
5. Terraform Null Resource `null_resource`
6. Terraform File Provisioner
7. Terraform remote-exec Provisioner
8. azurerm_bastion_host
9. Terraform Output Values


- **Pre-requisite Note:**
You should have completed the previous sections and should have all the files from the previous section , we'll be resuing them

### **Implementing Bastion Host Linux VM and Azure Bastion Service**  

This implementation focuses on setting up **two secure access options** for Azure VMs. Both solutions prevent **public IP exposure** on internal VMs, ensuring security.  
1. **Bastion Host Linux VM** – A self-managed virtual machine (jump server) used for secure SSH access.  
2. **Azure Bastion Service (ABS)** – A **fully managed platform service** that enables **browser-based** secure access to VMs.  


**Subnet Requirements for Bastion Implementations**  
- **Existing Bastion Subnet**  
    - A **Bastion subnet** was previously created as part of the **four-tier virtual network** (c8-bastion_subnet_nsg_association.tf).  
    - **Address range:** `10.1.100.0/24`  
    - This subnet will be used to deploy **Bastion Host Linux VM**.  

- **Azure Bastion Service Subnet Requirement**  
    - **Azure Bastion Service (ABS)** requires a **dedicated subnet**.  
    - This subnet **cannot be shared** with other resources.  
    - **New subnet details:**  
        - **Name:** `AzureBastionSubnet`  
        - **Address range:** `10.0.101.0/27`  
        - **Based on the default VNet address space:** `10.0.0.0/16`  
 

### **Step-01: c11-01-bastion-service-input-variables.tf**  

We'll define the folloing vars **For Azure Bastion Service** (`bastion_service_subnet_name`, `bastion_service_address_prefixes`).  
```hcl
# bastion service realted input vars
variable "bastion_service_subnet_name" {
    description = "Bastion Service Subnet Name"
    default = "AzureBastionSubnet" // should not be changed
}

variable "bastion_service_address_prefixes" {
    description = "Bastion Service Address Prefixes"
    default = ["10.0.101.0/27"]
}
```
- The terraform .tfvars for the bastion service will be updated as follows:  
  - Azure Bastion subnet uses `10.1.101.0/27` for **Azure Bastion Service**. 
    ```hcl
    bastion_service_subnet_name = "AzureBastionSubnet"
    bastion_service_address_prefixes = ["10.1.101.0/27"] 
    ```

### **Step-02: c11-02-bastion-host-linuxvm.tf**  
A **Bastion Host Linux VM** offers a **self-managed jump server** alternative for secure SSH access.

 **Defining Infrastructure Components for Bastion Host Linux VM**  
- **1. Public IP for the Bastion VM**  
    - A **static** public IP is assigned for consistent remote access.  
    - The SKU is set to **Standard** for improved availability.  
    - The resource name follows the pattern:  
    ```plaintext
    <resource_name_prefix>-bastion-host-publicip
  ```
- **2. Network Interface (NIC) for the Bastion VM**  
    - The NIC allows the VM to connect to the **Bastion subnet** inside the Virtual Network (VNet).  
    - The private IP is dynamically assigned.  
    - The NIC is linked to the **public IP** created earlier.

- **3. Bastion Linux VM Configuration**  
    - The VM uses the **Standard_DS1_v2** size.  
    - The **admin username** is set to `azureuser`.  
    - The **network interface** is attached to the VM.  
    - The **OS disk and SSH keys** are configured as per best practices.  
    - The **default image** used is RedHat, but it can be replaced with Ubuntu or any preferred Linux distribution.
