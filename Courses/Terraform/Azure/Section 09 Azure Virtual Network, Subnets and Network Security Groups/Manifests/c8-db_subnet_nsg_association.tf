# db subnet
resource "azurerm_subnet" "dbsubnet" {
    name = "${azurerm_virtual_network.vnet.name}-${var.db_subnet_name}"
    resource_group_name = azurerm_resource_group.myrg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = var.db_subnet_address
}

# db subnet nsg
resource "azurerm_network_security_group" "db_subnet_nsg"  {
    name = "${azurerm_subnet.dbsubnet.name}-nsg"
    location = azurerm_resource_group.myrg.location
    resource_group_name = azurerm_resource_group.myrg.name

}

# NSG Rules
## Locals Block for Security Rules
locals {
  db_inbound_ports_map = {
    "100" : "3306", # If the key starts with a number, you must use the colon syntax ":" instead of "="
    "110" : "1433",
    "120" : "5432"
  } 
}

## NSG Inbound Rule for dbTier Subnets
resource "azurerm_network_security_rule" "db_nsg_rule_inbound" {
  for_each = local.db_inbound_ports_map
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
  network_security_group_name = azurerm_network_security_group.db_subnet_nsg.name
}

# associate db subnet & nsg
resource "azurerm_subnet_network_security_group_association" "db_subnet_nsg_association"{
    subnet_id = azurerm_subnet.dbsubnet.id
    network_security_group_id = azurerm_network_security_group.db_subnet_nsg.id

# Every NSG Rule Association will disassociate NSG from Subnet and Associate it, so we associate it only after NSG is completely created - Azure Provider Bug 
# https://github.com/terraform-providers/terraform-provider-azurerm/issues/354 
    depends_on = [
        azurerm_network_security_rule.db_nsg_rule_inbound 
    ]
}