### Terraform Deployment Using `for_each` with Maps  

In the previous demonstration, the `count` meta-argument was used to implement a use case. Now, the same use case will be implemented using the `for_each` meta-argument, which will allow the creation of multiple web VMs along with a standard Azure load balancer and inbound NAT rules.  

This approach will demonstrate how `for_each` works in combination with multiple Azure resources, including:  
- Azure Web Linux VMs  
- Azure VM Network Interfaces (NICs)  
- Azure Standard Load Balancer  
- Load Balancer Backend Pool Associations  
- Load Balancer Inbound NAT Rules  

Additionally, several Terraform functions will be explored, including:  
- `for` expression  
- `lookup` function  
- `keys` function  
- `values` function  

If the Bastion host is required, it can be included. Otherwise, its configuration should be commented out in all related files.


### Step 1: Define Input Variables (`web-linuxvm-input-variables.tf`)

Previously, a variable of type `number` was used for specifying the number of instances. Now, a map of strings will be used to define VM details along with their corresponding inbound NAT ports:  

```hcl
variable "web_linuxvm_instance_details" {
  description = "Web Linux VM instance Count"
  type        = map(string)
  default = {
    "vm-1" = "2022",
    "vm-2" = "3022",
    "vm-3" = "4022"
  }
}
```

This map allows the definition of multiple VMs along with their respective inbound NAT rule ports. Using `for_each`, all the necessary components—Web Linux VMs, VM NICs, load balancer associations, and inbound NAT rules—can be created efficiently.  

### Step 2: Updating `terraform.tfvars`  
The defined map variable must be added to `terraform.tfvars` to ensure the appropriate values are used during Terraform execution. Additional instances can be added by adding more key-value pairs inside the map.  
```sh
web_linuxvm_instance_details = {
    "vm-1" = "2022",
    "vm-2" = "3022",
    "vm-3" = "4022",
}
```

### Step 3: Implementing Network Interface Configuration

The `for_each` meta-argument will be used to create multiple network interfaces dynamically based on the defined map:  

```hcl
resource "azurerm_network_interface" "web_linuxvm_nic" {
  for_each = var.web_linuxvm_instance_details

  name                = "${local.resource_name_prefix}-web-linuxvm-nic-${each.key}"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "web-linuxvm-ip-1"
    subnet_id                     = azurerm_subnet.websubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
```
- Here, `for_each` is set to `var.web_linuxvm_instance_details`, ensuring that a network interface is created for each VM key (e.g., `vm-1`, `vm-2`, etc.).  
    - The name of each NIC is generated dynamically using `${each.key}` to ensure uniqueness.  
    - The `each.key` represents the VM name (e.g., `vm-1`), while `each.value` represents the corresponding inbound NAT rule port.  

- **Key Differences Between `count` and `for_each`**
    - **`count`** is index-based (0, 1, 2, …), meaning resources are referenced using numeric indices.  
    - **`for_each`** is key-based, allowing the creation of resources with meaningful identifiers (`vm-1`, `vm-2`, etc.).  
    - For example:  
        - Using `count`: The first NIC would be referenced as `azurerm_network_interface.web_linuxvm_nic[0]`.  
        - Using `for_each`: The first NIC would be referenced as `azurerm_network_interface.web_linuxvm_nic["vm-1"]`.  

- Accessing `each.key` and `each.value`  
    - When using `for_each` with maps:  
        - `each.key` returns the map key (e.g., `vm-1`, `vm-2`).  
        - `each.value` returns the corresponding value (e.g., the NAT port `2022`, `3022`).  
    - If `for_each` is used with a **set of strings**, `each.key` and `each.value` will be the same, since sets contain only unique values.  


### Step 4: Terraform Configuration for Linux Virtual Machines  

The following configuration uses `for_each` to dynamically create the VMs based on the previously defined `web_linuxvm_instance_details` variable:  

```sh
resource "azurerm_linux_virtual_machine" "web_linuxvm" {
  for_each = var.web_linuxvm_instance_details

  name                = "${local.resource_name_prefix}-web-linuxvm-${each.key}"
  # 
  # 
  os_disk {
    name                 = "${local.resource_name_prefix}-web-linuxvm-osdisk-${each.key}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  # 
  network_interface_ids = [azurerm_network_interface.web_linuxvm_nic[each.key].id]
}
```

- **Using `for_each` to Create Multiple VMs**  
   - `for_each = var.web_linuxvm_instance_details` ensures that each VM is created based on the defined map.  
   - Each VM instance is uniquely identified using `each.key`.  

- **Naming Conventions**  
   - The VM name is generated dynamically as `"${local.resource_name_prefix}-web-linuxvm-${each.key}"`.  
   - The OS disk follows a similar pattern: `"${local.resource_name_prefix}-web-linuxvm-osdisk-${each.key}"`.  

- **Network Interface Association**  
   - The NIC associated with the VM is referenced as:  
     ```hcl
     network_interface_ids = [azurerm_network_interface.web_linuxvm_nic[each.key].id]
     ```  
   - This ensures that each VM is connected to its corresponding NIC.  
 
### Summary  

- The `for_each` meta-argument is used to dynamically create multiple web VMs, NICs, load balancer associations, and NAT rules.  
- A **map of strings** is used to store VM names and their corresponding inbound NAT ports.  
- The configuration ensures that each resource instance has a unique identifier, improving readability and maintainability.  
- `each.key` is used to generate unique names for NICs, while `each.value` can be used to retrieve associated properties.  
- This approach provides greater flexibility compared to `count`, as it allows direct referencing using meaningful names instead of numeric indices.