resource "azurerm_kubernetes_cluster_node_pool" "aks-user-nodepool" {
    name = "usernodepool"
    kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
    os_type = "Linux"
    vm_size = "Standard_DS2_v2"
    auto_scaling_enabled = true
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    max_count = 2
    min_count = 1
    os_disk_size_gb = 30
    mode = "User"
    node_labels = {
      "nodepool-type"    = "user"
      "environment"      = var.environment
      "nodepoolos"       = "linux"
      "app"              = "java-apps" 
    } 
    tags = {
      "nodepool-type"    = "user"
      "environment"      = var.environment
      "nodepoolos"       = "linux"
      "app"              = "java-apps" 
    } 
}