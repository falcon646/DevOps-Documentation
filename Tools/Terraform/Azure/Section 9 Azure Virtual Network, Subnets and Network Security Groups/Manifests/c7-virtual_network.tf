resource "azurerm_virtual_network" "vnet" {
   name = "${local.resource_name_prefix}-${var.vnet_name}"
   location = azurerm_resource_group.myrg.location
   resource_group_name =  azurerm_resource_group.myrg.name
   address_space = var.vnet_address_space
   tags = local.common_tags
}