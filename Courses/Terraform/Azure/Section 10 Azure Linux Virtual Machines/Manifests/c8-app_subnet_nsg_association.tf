# app subnet
resource "azurerm_subnet" "appsubnet" {
    name = "${azurerm_virtual_network.vnet.name}-${var.app_subnet_name}"
    resource_group_name = azurerm_resource_group.myrg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = var.app_subnet_address
}

# app subnet nsg
resource "azurerm_network_security_group" "app_subnet_nsg"  {
    name = "${azurerm_subnet.appsubnet.name}-nsg"
    location = azurerm_resource_group.myrg.location
    resource_group_name = azurerm_resource_group.myrg.name

}

# NSG Rules
## Locals Block for Security Rules
locals {
  app_inbound_ports_map = {
    "100" : "80", # If the key starts with a number, you must use the colon syntax ":" instead of "="
    "110" : "443",
    "120" : "8080",
    "130" : "22"
  } 
}

## NSG Inbound Rule for appTier Subnets
resource "azurerm_network_security_rule" "app_nsg_rule_inbound" {
  for_each = local.app_inbound_ports_map
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
  network_security_group_name = azurerm_network_security_group.app_subnet_nsg.name
}

# associate app subnet & nsg
resource "azurerm_subnet_network_security_group_association" "app_subnet_nsg_association"{
    subnet_id = azurerm_subnet.appsubnet.id
    network_security_group_id = azurerm_network_security_group.app_subnet_nsg.id

# Every NSG Rule Association will disassociate NSG from Subnet and Associate it, so we associate it only after NSG is completely created - Azure Provider Bug 
# https://github.com/terraform-providers/terraform-provider-azurerm/issues/354 
    depends_on = [
        azurerm_network_security_rule.app_nsg_rule_inbound 
    ]
}