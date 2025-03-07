# Create Outputs
# 1. Resource Group Location
output "location" {
  value = azurerm_resource_group.aks_rg.location
}
# 2. Resource Group Id
output "resource_group_id" {
  value = azurerm_resource_group.aks_rg.id
}
# 3. Resource Group Name

output "resource_group_name" {
  value = azurerm_resource_group.aks_rg.name
}