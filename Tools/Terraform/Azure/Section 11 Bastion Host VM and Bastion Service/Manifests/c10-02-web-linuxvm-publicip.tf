# comeneted since the linux vm in web subnet needs to be private 
# resource "azurerm_public_ip" "web_linuixvm_publicip" {
#     name = "${local.resource_name_prefix}-web-linuxvm-publicip"
#     resource_group_name = azurerm_resource_group.myrg.name
#     location = azurerm_resource_group.myrg.location
#     allocation_method = "Static"
#     sku = "Standard"
#     domain_name_label = "app1-vm-${random_string.myrandom.id}"
  
# }