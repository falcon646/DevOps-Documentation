
### **Network Security Group (NSG) & NIC Assoctaion**  

In this lecture, we will review the **virtual machine network security group (NSG) resources**.  

The **web NSG** has already been created , along with all other NSG-related code.  

Similarly, for the **VM NSG**, the process remains the same, with only **one minor difference** in the resource definition.  

In the **web NSG**, the security group was associated with a **subnet**.  
Here, the NSG will be associated with a **network interface (NIC)**.  

This **NSG-to-NIC association** is the only difference in the template. We will 

####  **Step 04 : c10-04-web-linuxvm-network-security-group.tf**
- The first  is the creation of an **NSG**, which we have already seen before.  
    ```hcl
    resource "azurerm_network_security_group" "web_vmnic_nsg" {
        name = "${azurerm_network_interface.web_linuxvm_nic}-nsg"
        location = azurerm_resource_group.myrg.location
        resource_group_name  = azurerm_resource_group.myrg.name
    }
    ```
- **Associating the NSG with the NIC**  
   - The **second resource** in the configuration is the **NSG-to-NIC association**.  
   - The rest of the code remains unchanged, except for this association.  
   - It includes:  
     - **Inbound ports mapping** (priority, port number).  
     - **Azure RM network security rules** for traffic filtering.  
  - **NSG Association Types**  
   - There are **two types** of NSG associations:  
     1. **Subnet-based NSG association**  : Links an NSG to an entire **subnet** (affects all VMs within).  
     2. **NIC-based NSG association**  : Links an NSG **directly to a specific VM's NIC**.  

7. **Dependencies and Ordering**  
   - The association happens **only after** all security rules are created.  
   - The **depends_on** meta-argument ensures that the NSG rules are fully defined before applying the association.  
     ```hcl
     depends_on = [azurerm_network_security_rule.web_vmnic_nsg_rule_inbound]
     ```
   - This guarantees that security rules are enforced properly before linking the NSG to the NIC.  

```hcl
# Resource-2: Associate NSG and Linux VM NIC
resource "azurerm_subnet_network_interface_security_group_association" "web_vmnic_nsg_associate" {
    network_security_group_id = azurerm_network_security_group.web_vmnic_nsg.id
    network_interface_id = azurerm_network_interface.web_linuxvm_nic.id
    depends_on = [ azurerm_network_security_rule.web_vmnic_nsg_rule_inbound ]
}

# Resource-3: Create NSG Rules
## Locals Block for Security Rules
locals {
  web_vmnic_inbound_ports_map = {
    "100" : "80", # If the key starts with a number, you must use the colon syntax ":" instead of "="
    "110" : "443",
    "120" : "22"
  } 
}
## NSG Inbound Rule for WebTier Subnets
resource "azurerm_network_security_rule" "web_vmnic_nsg_rule_inbound" {
  for_each = local.web_vmnic_inbound_ports_map
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value 
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.web_vmnic_nsg.name
}
```