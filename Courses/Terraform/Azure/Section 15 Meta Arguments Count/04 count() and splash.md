# Terraform: Implementing Multiple Instances of a Linux VM Using `count` Meta-Argument  

This section explains how to create multiple instances of an Azure Linux virtual machine (`azurerm_linux_virtual_machine`) using Terraform's `count` meta-argument. Additionally, it covers the use of `element()` and splat (`[*]`) expressions for associating network interfaces with each VM.

### **Understanding `splat[*]` and `element()` Expressions**  
- `splat[*] expression` : 
    - A splat expression provides a more concise way to express a common operation that could otherwise be performed with a for expression.
    - If `var.list` is a list of objects that all have an attribute id, then a list of the ids could be produced with the following for expression: `[for o in var.list : o.id]`
    - This is equivalent to the following splat expression: `var.list[*].id`
    - The special `[*]` symbol iterates over all of the elements of the list given to its left and accesses from each one the attribute name given on its right. 
    - A splat expression can also be used to access attributes and indexes from lists of complex types by extending the sequence of operations to the right of the symbol: `var.list[*].interfaces[0].name` 
    - The above expression is equivalent to the following for expression: `[for o in var.list : o.interfaces[0].name]`

- `element()`
    - element() retrieves a single element from a list. syntax `element(list, index)`. 
    - It takes 2 arguments , 1st one the the list which contains mutipkle values and ethe 2nd ons the index from which the value needs to be fetched. 
    - The index is zero-based. This function produces an error if used with an empty list. 
    - The index must be a non-negative integer. 
    - eg if the list is listnicid = ["101" , "102" , "103 , 104 , ..] , to get the 2nd element from the list , use element(listnicid, 1) 

### Step 4: Associating NICs with VMs
- **1. Using `count` to Create Multiple VMs**  
    - The `count` meta-argument allows defining multiple instances of a resource with a single configuration block. It accepts an integer value and creates that many instances of the resource.  
    ```hcl
    resource "azurerm_linux_virtual_machine" "web_linuxvm" {
        count = var.web_linuxvm_instance_count
        name  = "${local.resource_name_prefix}-web-linuxvm-${count.index}"
    }
    ```
    - The `count` value is set to `var.web_linuxvm_instance_count`, which determines the number of VM instances.
    - `count.index` generates unique names for each VM by appending an index number (0,1,2,3,4).

- **2. Attaching Network Interfaces to VMs**
    - Each VM requires a corresponding network interface. The `count` meta-argument is already applied to the network interface resource to create multiple instances.
        ```hcl
        resource "azurerm_network_interface" "web_linuxvm_nic" {
        count = var.web_linuxvm_instance_count
        name  = "${local.resource_name_prefix}-web-linuxvm-nic-${count.index}"
        }
        ``
    - **Using the Splat Expression to Get NIC IDs**
      ```hcl
      network_interface_ids = [ azurerm_network_interface.web_linuxvm_nic[*].id ]
      ```
      - The `[ * ]` symbol retrieves all network interface IDs as a list.
    - **Using `element()` to Assign NICs to VMs**
      ```hcl
      network_interface_ids = [ element(azurerm_network_interface.web_linuxvm_nic[*].id , count.index) ]
      ```
      - The `element()` function picks the corresponding NIC for each VM using `count.index`.
      - When `count.index = 0`, the first NIC is assigned, and so on.


**Final VM Configuration with NIC Attachment**
```hcl
resource "azurerm_linux_virtual_machine" "web_linuxvm" {
  count                = var.web_linuxvm_instance_count
  name                 = "${local.resource_name_prefix}-web-linuxvm-${count.index}"
  resource_group_name  = azurerm_resource_group.myrg.name
  location             = azurerm_resource_group.myrg.location
  computer_name        = "web-server"
  size                 = "Standard_DS1_v2"
  admin_username       = "azureuser"

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }

  os_disk {
    name                 = "${local.resource_name_prefix}-web-linuxvm-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface_ids = [ element(azurerm_network_interface.web_linuxvm_nic[*].id , count.index) ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(local.webvm_custom_data)
}
```


### **Key Takeaways**
- The `count` meta-argument is used to create multiple VM and NIC resources.
- `count.index` generates unique names for each instance.
- The splat (`[*]`) expression retrieves a list of all NIC IDs.
- The `element()` function ensures that each VM gets a unique NIC.

By leveraging these Terraform meta-arguments and functions, the code remains concise and scalable, making it easy to deploy multiple instances efficiently.