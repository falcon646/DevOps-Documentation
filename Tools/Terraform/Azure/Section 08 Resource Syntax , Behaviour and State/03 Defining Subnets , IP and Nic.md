### **Creating a Subnet**  
**Creating the Subnet (`mysubnet-1`)**  
The subnet resource is defined using `azurerm_subnet`.  
- **`name`** → Specifies the subnet name (`mysubnet-1`).  
- **`resource_group_name`** → References `azurerm_resource_group.myrg.name`.  
- **`virtual_network_name`** → Links the subnet to `azurerm_virtual_network.myvnet.name`.  
- **`address_prefixes`** → A **list** of CIDR blocks (`["10.0.2.0/24"]`). 
```json
resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet-1"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
``` 
**Defining Subnets: Inline vs. Separate**  
Terraform allows defining subnets **inside** the virtual network resource or as a **separate** resource.  
- **Inline Subnet Definition (Inside Virtual Network)**
    - Simple** and **self-contained**, but limited flexibility.  
```json
resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "mysubnet-1"
    address_prefix = "10.0.2.0/24"
  }
}
```
- **Separate Subnet Resource (Recommended for Modularity)** 
    - **Modular** and **reusable**, allows defining multiple subnets separately.
```json
resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet-1"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
```
**Address Prefixes: List Notation (`[]`)**
The `address_prefixes` argument expects a **list** of CIDR blocks.  
```json
address_prefixes = ["10.0.2.0/24"]
// or multiple address spaces
address_prefixes = ["10.0.2.0/24", "10.0.3.0/24"]
```
-----
### **Creating a Public IP**  
The public IP resource is defined using `azurerm_public_ip`.

```hcl
resource "azurerm_public_ip" "mypublicip" {
  name                = "mypublicip-1"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"

  tags = {
    environment = "dev"
  }
}
```
- **Explanation:**
  - **`name`**: Specifies the public IP's name (`mypublicip-1`).
  - **`resource_group_name`**: References the resource group defined earlier (`azurerm_resource_group.myrg.name`).
  - **`location`**: Uses the location from the resource group (`azurerm_resource_group.myrg.location`).
  - **`allocation_method`**: Sets the allocation method to `Static` to ensure the IP address remains the same.

**Allocation Method**  : The `allocation_method` is set to `Static`, meaning the public IP address will be persistent and not change over time.

-----
### **Creating a Network Interface**
To create a network interface in Azure, we define it using the `azurerm_network_interface` resource.

```hcl
resource "azurerm_network_interface" "myvmnic" {
  name                = "vmnic"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypublicip.id
  }
}
```
**Explanation:**
  - **`name`**: Specifies the name of the network interface, here it's `vmnic`.
  - **`location`**: Uses the resource group's location, ensuring it matches the group's location.
  - **`resource_group_name`**: References the resource group for the NIC.
  - **`ip_configuration` Block** : The **IP configuration** is a block within the network interface configuration. Here, multiple properties are defined, including the **subnet**, **private IP allocation**, and **public IP association**.
    - **`name`**: Sets the name of the IP configuration (in this case, `internal`).
    - **`subnet_id`**: Specifies the **subnet** where the network interface is placed, referencing the subnet resource created earlier.
      ```hcl
      subnet_id = azurerm_subnet.mysubnet.id
      ```
    - **`private_ip_address_allocation`**: Defines whether the private IP is dynamic or static. Here, it’s set to `Dynamic`, meaning the private IP will be assigned dynamically by Azure.
    - **`public_ip_address_id`**: Associates the **public IP** with this network interface by referencing the public IP’s ID.
      ```hcl
      public_ip_address_id = azurerm_public_ip.mypublicip.id
      ```
**Differences: Blocks vs. Arguments**
- **`tags`**: An **argument** in the resource block with a key-value pair, passed as a map:
  ```hcl
  tags = {
    environment = "dev"
  }
  ```
- **`ip_configuration`**: A **block** inside the resource block. The block structure is denoted by curly braces `{}` but does not have an equal sign (`=`) like an argument. It defines specific sub-attributes like `name`, `subnet_id`, and `private_ip_address_allocation`.

This distinction is crucial when working with complex resources in Terraform.

**Reference and Attribute Verification**

- **Subnet Reference**: You reference the subnet ID from the `azurerm_subnet.mysubnet.id` to link the NIC to the subnet.
- **Public IP Reference**: Similarly, the `public_ip_address_id` is linked to the `azurerm_public_ip.mypublicip.id`.

**Final Configuration Overview**

After creating and cross-referencing the virtual network, subnet, public IP, and network interface:
- **Subnet** is associated with the **virtual network**.
- **Public IP** is associated with the **network interface**.
- The **network interface** is assigned to the **subnet** with a dynamic **private IP** and an optional **public IP**.

