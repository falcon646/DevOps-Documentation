# Azure LB Inbound NAT Rule

resource "azurerm_lb_nat_rule" "web_ib_inbound-nat_rule_1022-22" {
  resource_group_name = azurerm_resource_group.myrg.name
  loadbalancer_id = azurerm_lb.web_lb.id
  name = "${azurerm_lb.web_lb.name}-inboud-nat-rule_1022-22"
  protocol = "Tcp"
  frontend_port = 2022
  backend_port =  22
  frontend_ip_configuration_name =  azurerm_lb.web_lb.frontend_ip_configuration[0].name
#   backend_address_pool_id = azurerm_lb_backend_address_pool.web_lb_backend_pool.id
}


# Associate LB NAT Rule and VM Network Interface
resource "azurerm_network_interface_nat_rule_association" "web_lb_nic_nat_rule_associatn" {
  network_interface_id =  azurerm_network_interface.web_linuxvm_nic.id
  ip_configuration_name = azurerm_network_interface.web_linuxvm_nic.ip_configuration[0].name
  nat_rule_id = azurerm_lb_nat_rule.web_ib_inbound-nat_rule_1022-22.id
}