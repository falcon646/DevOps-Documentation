### **Step 6: Terraform Load Balancer NAT Rules with Count Meta-Arguments**  

In the previous section, changes were made to the Terraform configuration to integrate `count` meta-arguments for network interfaces, virtual machines, and load balancer backend pool associations. This ensured that all virtual machine instances and network interfaces were correctly associated with the load balancer. Now, additional configuration changes are required to establish NAT rules per virtual machine from the Azure Load Balancer.

**Load Balancer NAT Rules Overview**
Each virtual machine (VM) requires a unique NAT rule that maps a frontend port to the VM's SSH port. The Terraform configuration should define multiple NAT rules dynamically using the `count` meta-argument.

For example:
- **VM 1** → SSH via Load Balancer Public IP on port `1022`
- **VM 2** → SSH via Load Balancer Public IP on port `2022`
- **VM 3** → SSH via Load Balancer Public IP on port `3022`
- **VM 4** → SSH via Load Balancer Public IP on port `4022`
- **VM 5** → SSH via Load Balancer Public IP on port `5022`

Instead of defining these NAT rules manually, Terraform will dynamically generate them based on the number of VMs.

`web-load-balancer-inbound-nat-rules.tf`

**Handling AzureRM Provider Dependency Bug** : In previous Terraform executions, an issue was encountered where destroying resources failed due to dependency conflicts. This was caused by a race condition between deleting NAT rules and deleting virtual machines. Since the AzureRM provider does not handle dependencies correctly in this case, a workaround is required.

To ensure that NAT rules are created **only after** virtual machines are provisioned and deleted **only after** virtual machines are removed, the `depends_on` argument is used:

```hcl
depends_on = [azurerm_linux_virtual_machine.web_linux_vm]
```

This ensures that:
- NAT rules are created **after** the VMs exist.
- NAT rules are deleted **after** the VMs are removed.

**Defining NAT Rules Dynamically**

Since each VM instance requires a unique NAT rule, Terraform uses the `count` meta-argument along with the `element` function to assign ports dynamically.

```hcl
resource "azurerm_lb_nat_rule" "web_lb_nat_rule" {
  count = var.web_linuxvm_instance_count

  name                           = "VM-${count.index}-SSH-${element(var.lb_inbound_nat_ports, count.index)}"
  resource_group_name            = azurerm_resource_group.web_rg.name
  loadbalancer_id                = azurerm_lb.web_lb.id
  frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
  protocol                       = "Tcp"
  frontend_port                  = element(var.lb_inbound_nat_ports, count.index)
  backend_port                   = 22
}
```
- **`count = var.web_linuxvm_instance_count`**   : Creates the same number of NAT rules as the number of virtual machines.
- **`name = "VM-${count.index}-SSH-${element(var.lb_inbound_nat_ports, count.index)}"`**   Assigns a unique name for each NAT rule based on the VM index and assigned inbound port. Example name: `VM-0-SSH-1022`
- **`frontend_port = element(var.lb_inbound_nat_ports, count.index)`**   : Extracts the appropriate frontend port from the predefined list (`var.lb_inbound_nat_ports`).
- **`backend_port = 22`**   All VMs will use port `22` for SSH access.


**Associating NAT Rules with Network Interfaces**

Each NAT rule must be linked to a corresponding VM's network interface. Terraform will create an association for each NAT rule.

```hcl
resource "azurerm_network_interface_nat_rule_association" "web_ib_inbound-nat_rule_22" {
count = var.web_linuxvm_instance_count
  network_interface_id =  azurerm_network_interface.web_linuxvm_nic[count.index].id
  ip_configuration_name = azurerm_network_interface.web_linuxvm_nic[count.index].ip_configuration[0].name
  nat_rule_id = azurerm_lb_nat_rule.web_ib_inbound-nat_rule_22[count.index].id

  # or
  # network_interface_id  = element(azurerm_network_interface.web_linuxvm_nic[*].id, count.index)
  # ip_configuration_name = element(azurerm_network_interface.web_linuxvm_nic[*].ip_configuration[0].name , count.index)
  # nat_rule_id           = element(azurerm_lb_nat_rule.web_ib_inbound-nat_rule_22[count.index].id  , count.index)       = element(azurerm_lb_nat_rule.web_lb_nat_rule[*].id, count.index)
}
```


- **`count = var.web_linuxvm_instance_count`** : Creates an association for each virtual machine.
2. **`network_interface_id = element(azurerm_network_interface.web_linuxvm_nic[*].id, count.index)`**   : Selects the correct network interface for each VM.
3. **`nat_rule_id = element(azurerm_lb_nat_rule.web_lb_nat_rule[*].id, count.index)`**  : Assigns the corresponding NAT rule to each VM.

