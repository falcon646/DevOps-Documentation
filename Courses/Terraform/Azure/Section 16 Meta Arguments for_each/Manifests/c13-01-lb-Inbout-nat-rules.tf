# Azure LB Inbound NAT Rule

resource "azurerm_lb_nat_rule" "web_ib_inbound-nat_rule_22" {
  for_each = var.web_linuxvm_instance_details

  depends_on = [ azurerm_linux_virtual_machine.web_linuxvm ]
  resource_group_name = azurerm_resource_group.myrg.name
  loadbalancer_id = azurerm_lb.web_lb.id
  name = "${azurerm_lb.web_lb.name}-${each.key}-inboud-nat-rule_${each.value}-22-ssh"
  protocol = "Tcp"
  frontend_port = each.value
  # or use frontend_port = lookup(var.web_linuxvm_instance_details , each.key)
  backend_port =  22
  frontend_ip_configuration_name =  azurerm_lb.web_lb.frontend_ip_configuration[0].name
#   backend_address_pool_id = azurerm_lb_backend_address_pool.web_lb_backend_pool.id
}


# Associate LB NAT Rule and VM Network Interface
resource "azurerm_network_interface_nat_rule_association" "web_lb_nic_nat_rule_associatn" {
  for_each = var.web_linuxvm_instance_details

  network_interface_id =  azurerm_network_interface.web_linuxvm_nic[each.key].id
  ip_configuration_name = azurerm_network_interface.web_linuxvm_nic[each.key].ip_configuration[0].name
  nat_rule_id = azurerm_lb_nat_rule.web_ib_inbound-nat_rule_22[each.key].id

  # or
  # network_interface_id  = element(azurerm_network_interface.web_linuxvm_nic[*].id, count.index)
  # ip_configuration_name = element(azurerm_network_interface.web_linuxvm_nic[*].ip_configuration[0].name , count.index)
  # nat_rule_id           = element(azurerm_lb_nat_rule.web_ib_inbound-nat_rule_22[*.id  , count.index)
}