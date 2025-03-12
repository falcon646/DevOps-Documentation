resource "azurerm_network_interface" "web_linuxvm_nic" {
for_each = var.web_linuxvm_instance_details

  name = "${local.resource_name_prefix}-web-linuxvm-nic-${each.key}"
  location = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name = "web-linuxvm-ip-1"
    subnet_id = azurerm_subnet.websubnet.id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id = azurerm_public_ip.web_linuixvm_publicip.id
  }
}