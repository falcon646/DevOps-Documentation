# Create Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "insights" {
  name = "logs-${random_string.random.id}"
  location = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  sku = "PerGB2018"
  retention_in_days = "30"
}