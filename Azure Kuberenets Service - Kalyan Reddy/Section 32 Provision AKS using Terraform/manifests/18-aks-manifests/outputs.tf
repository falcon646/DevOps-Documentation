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

# 4. aks version
output "aks_all_versions" {
  value = data.azurerm_kubernetes_service_versions.current.versions
}
# 5. aks latest version
output "aks_latest_version" {
  value = data.azurerm_kubernetes_service_versions.current.latest_version
}

# Azure AD Group  Id
output "azure_ad_group_id" {
  value = azuread_group.aks_administrators.id
}

# Azure AD Group Object Id
output "azure_ad_group_objectid" {
  value = azuread_group.aks_administrators.object_id
}


output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.insights.id
}

# Azure AKS Outputs

output "aks_cluster_id" {
  value = azurerm_kubernetes_cluster.aks_cluster.id
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.name
}

output "aks_cluster_kubernetes_version" {
  value = azurerm_kubernetes_cluster.aks_cluster.kubernetes_version
}