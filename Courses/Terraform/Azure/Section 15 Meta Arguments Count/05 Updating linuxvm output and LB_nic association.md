
### **Step 5: Terraform Output Configuration Using Splat Expressions**  

The following output values use splat expressions to retrieve lists of relevant attributes:

```hcl
## Web Linux VM Network Interface IDs
output "web_linuxvm_network_interface_id" {
  description = "Web Linux VM Network Interface ID"
  value = azurerm_network_interface.web_linuxvm_nic[*].id
}

## Web Linux VM Private IP Addresses
output "web_linuxvm_network_interface_private_ip_addresses" {
  description = "Web Linux VM Private IP Addresses"
  value = azurerm_network_interface.web_linuxvm_nic[*].private_ip_addresses
}

## Web Linux VM Private IP Address
output "web_linuxvm_private_ip_address" {
  description = "Web Linux Virtual Machine Private IP"
  value = azurerm_linux_virtual_machine.web_linuxvm[*].private_ip_address
}

## Web Linux VM 128-bit Identifier
output "web_linuxvm_virtual_machine_id_128bit" {
  description = "Web Linux Virtual Machine ID - 128-bit identifier"
  value = azurerm_linux_virtual_machine.web_linuxvm[*].virtual_machine_id
}

## Web Linux VM Resource ID
output "web_linuxvm_virtual_machine_id" {
  description = "Web Linux Virtual Machine ID"
  value = azurerm_linux_virtual_machine.web_linuxvm[*].id
}
```
- **Network Interface IDs (`id`)** : `azurerm_network_interface.web_linuxvm_nic[*].id` retrieves a list of **all network interface IDs** for the created VMs.
- **Private IP Addresses of Network Interfaces**  : `azurerm_network_interface.web_linuxvm_nic[*].private_ip_addresses` collects the **private IPs** of all the network interfaces.
- **Private IP Addresses of Virtual Machines**  : `azurerm_linux_virtual_machine.web_linuxvm[*].private_ip_address` retrieves **all private IP addresses** assigned to the VMs.
- **Virtual Machine 128-bit Identifier**   : `azurerm_linux_virtual_machine.web_linuxvm[*].virtual_machine_id` fetches **all 128-bit unique IDs** of the created VMs.
- **Virtual Machine IDs**  : `azurerm_linux_virtual_machine.web_linuxvm[*].id` provides **the list of resource IDs** assigned to the VMs.

---

### **Step 5: Terraform Output Configuration**  

### **Associating Network Interfaces with a Load Balancer Using Terraform**  

In this section, the `azurerm_network_interface_backend_address_pool_association` resource is introduced. This resource ensures that all **network interfaces (NICs) of virtual machines (VMs)** created using the `count` meta-argument are associated with the **backend address pool** of the standard Azure Load Balancer.

- Since `count` was used while creating `azurerm_linux_virtual_machine`, multiple VM instances exist.
- Each VM has its own **network interface (NIC)**.
- All **NICs must be registered in the backend pool** of the Load Balancer.
- To automate this, the `count` meta-argument is used for **backend address pool association**, ensuring that each NIC is linked to the backend pool dynamically.

**Terraform Configuration: Associating NICs with the Load Balancer**

```hcl
# Resource-6: Associate Network Interface and Standard Load Balancer

resource "azurerm_network_interface_backend_address_pool_association" "web_lb_nic_be_association" {
    count = var.web_linuxvm_instance_count

    # Associate each VM's NIC using either element() or direct index referencing
    network_interface_id = element(azurerm_network_interface.web_linuxvm_nic[*].id, count.index)
    # Alternative approach:
    # network_interface_id = azurerm_network_interface.web_linuxvm_nic[count.index].id 

    # Assign the correct IP configuration for each NIC
    ip_configuration_name = azurerm_network_interface.web_linuxvm_nic[count.index].ip_configuration[0].name

    # Assign the backend address pool to the NIC
    backend_address_pool_id = azurerm_lb_backend_address_pool.web_lb_backend_pool.id
}
```

- **`count = var.web_linuxvm_instance_count`**  
   - This ensures that the same number of `azurerm_network_interface_backend_address_pool_association` instances are created as the number of VMs.

-  **NIC Association with Load Balancer**  
   - The NICs must be associated with the **Load Balancer Backend Pool**.
   - **Two methods** can be used to select the correct NIC instance:
     - **Using `element()` function:**  
       ```hcl
       network_interface_id = element(azurerm_network_interface.web_linuxvm_nic[*].id, count.index)
       ```
     - **Using direct indexing (`count.index`)** (simpler and preferred approach):  
       ```hcl
       network_interface_id = azurerm_network_interface.web_linuxvm_nic[count.index].id
       ```
- **IP Configuration Name Assignment**
   - Since each NIC has an `ip_configuration` block, the configuration name must be extracted correctly.
   - This is done using:
     ```hcl
     ip_configuration_name = azurerm_network_interface.web_linuxvm_nic[count.index].ip_configuration[0].name
     ```



### **Why Use Variables for Scaling?**
- The variable **`var.web_linuxvm_instance_count`** dynamically controls the number of VM instances.
- If the instance count is changed from `5` to `10`, Terraform automatically:
  - Creates 10 VM instances.
  - Creates 10 NICs.
  - Associates all 10 NICs with the Load Balancer backend pool.
- **No manual modifications** are needed across multiple Terraform files.


### **Key Takeaways**
- **Terraform dynamically associates NICs with the Load Balancer Backend Pool.**
- **Both `element()` and direct indexing (`count.index`) can be used for resource referencing.**
- **Using variables enables easy scaling** without modifying multiple Terraform files.
- **This method ensures all VM instances are properly load-balanced** in the backend pool.

With this configuration complete, the next step involves configuring **Load Balancer NAT rules** for managing inbound traffic.