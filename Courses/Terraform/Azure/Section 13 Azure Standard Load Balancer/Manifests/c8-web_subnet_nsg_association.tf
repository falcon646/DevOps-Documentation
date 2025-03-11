# web subnet
resource "azurerm_subnet" "websubnet" {
    name = "${azurerm_virtual_network.vnet.name}-${var.web_subnet_name}"
    resource_group_name = azurerm_resource_group.myrg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = var.web_subnet_address
}

# web subnet nsg
resource "azurerm_network_security_group" "web_subnet_nsg"  {
    name = "${azurerm_subnet.websubnet.name}-nsg"
    location = azurerm_resource_group.myrg.location
    resource_group_name = azurerm_resource_group.myrg.name

}

# NSG Rules
## Locals Block for Security Rules
locals {
  web_inbound_ports_map = {
    "100" : "80", # If the key starts with a number, you must use the colon syntax ":" instead of "="
    "110" : "443",
    "120" : "22"
  } 
}

## NSG Inbound Rule for WebTier Subnets
resource "azurerm_network_security_rule" "web_nsg_rule_inbound" {
  for_each = local.web_inbound_ports_map
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value 
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.myrg.name
  network_security_group_name = azurerm_network_security_group.web_subnet_nsg.name
}

# associate web subnet & nsg
resource "azurerm_subnet_network_security_group_association" "web_subnet_nsg_association"{
    subnet_id = azurerm_subnet.websubnet.id
    network_security_group_id = azurerm_network_security_group.web_subnet_nsg.id

# Every NSG Rule Association will disassociate NSG from Subnet and Associate it, so we associate it only after NSG is completely created - Azure Provider Bug 
# https://github.com/terraform-providers/terraform-provider-azurerm/issues/354 
    depends_on = [
        azurerm_network_security_rule.web_nsg_rule_inbound 
    ]
}