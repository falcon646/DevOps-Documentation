### **Creating an Azure Bastion Service Resources**  

**c11-04-AzureBastionService.tf**

- **1. Creating the Bastion Service Subnet**   : The **Azure Bastion subnet** is required to provide a secure connection to **Azure VMs** without exposing them to the public internet.  
    ```hcl
    resource "azurerm_subnet" "bastion_service_subnet" {
    name                 = var.bastion_service_subnet_name
    resource_group_name  = data.azurerm_resource_group.rg.name
    virtual_network_name = data.azurerm_virtual_network.vnet.name
    address_prefixes     = var.bastion_service_address_prefixes
    }
    ```
    - **`name`**: The **Bastion subnet** must have a fixed name, `AzureBastionSubnet`.  
    - **`resource_group_name`**: The resource group name is fetched from the **data source**.  
    - **`virtual_network_name`**: The **virtual network name** is retrieved from the existing **virtual network**.  
    - **`address_prefixes`**: The **CIDR range** is defined in the **input variables**.  


- **2. Creating the Bastion Service Public IP**   : The **Bastion service** requires a **public IP** to allow secure access.  
    ```hcl
    # Resource-2: Azure Bastion Public IP
    resource "azurerm_public_ip" "bastion_service_publicip" {
    name = "${local.resource_name_prefix}-bastion-service-publicip"
    resource_group_name = azurerm_resource_group.myrg.name
    location            = azurerm_resource_group.myrg.location
    allocation_method   = "Static"
    sku = "Standard"
    }
    ```
- **3. Creating the Azure Bastion Service Host** :  The **Azure Bastion Service Host** is the final component required to set up a secure remote access solution in Azure. This Terraform configuration will define the **Bastion host**, linking it to the **previously created subnet and public IP**.  
    ```hcl
    # Resource-3: Azure Bastion Service Host
    resource "azurerm_bastion_host" "bastion_host" {
        name = "${locals.resource_name_prefix}-bastion-service"
        location = azurerm_resource_group.myrg.location
        resource_group_name = azurerm_resource_group.myrg.name

        ip_configuration {
            name = "configuration"
            subnet_id = azurerm_subnet.bastion_service_subnet.id
            public_ip_address_id = azurerm_public_ip.bastion_service_publicip.id
        }
    }
    ```
    - **`name`**:   The Bastion host name follows the format **`local.resource_name_prefix-bastion-service`**.  
    - **`location`**:  Retrieved dynamically from the **resource group’s location**.  
    - **`resource_group_name`**:   The **resource group name** is referenced from the **existing data source**.  
    - **`ip_configuration`**:  
        - **`name`**: Assigned as `"congiguration"`.  
        - **`subnet_id`**: Linked to the **Bastion service subnet** (`azurerm_subnet.bastion_service_subnet.id`).  
        - **`public_ip_address_id`**: Associated with the **Bastion service public IP** (`azurerm_public_ip.bastion_service_ip.id`).  
    - **SKU (Service Tier)**:  The **SKU (Standard or Basic)** is  optional for Bastion service configuration , defaults to basic



**c11-05-bastion-outputs.tf**

To facilitate secure access to internal resources, we need to extract the **public IP address** of the **Bastion Host**. This will enable SSH access to internal VMs.  

```hcl
## Bastion Host Public IP Output
output "bastion_host_linuxvm_public_ip_address" {
  description = "Bastion Host Linux VM Public Address"
  value = azurerm_public_ip.bastion_host_publicip.ip_address
}
```

**Modifying Terraform Variables (`terraform.tfvars`)**  

Before executing Terraform, the following variables must be defined in the **`terraform.tfvars`** file:  
- **`bastion_service_subnet_name`**: Ensures that the subnet is properly recognized.  
- **`bastion_service_address_prefixes`**: Defines the subnet range for the Bastion service.

```hcl
bastion_service_subnet_name = "AzureBastionSubnet"
bastion_service_address_prefixes = ["10.1.101.0/27"]
```



#### **Configuring the Web Linux VM for Internal Access Only**  

By default, a public IP is assigned to the **Linux VM**. However, in a **secure architecture**, the VM should only be accessible **through the Bastion Host**.  

**Changes to be made:**  
1. **Comment out the public IP configuration** in the Web Linux VM resource.  (`c10-02-web-linuxvm-publicip.tf`)
2. **Comment out the public IP reference** in the network interface configuration. (`c10-03-web-linuxvm-network-interface.tf`)
3. **Comment out the out vars block for the public IP reference** in the web-linuxvm-outputs (`c10-06-web-linuxvm-outputs.tf`)
3. **Comment out the nsg resource for web lunixvm** (`c10-04-web-linuxvm-network-security-group.tf`)




