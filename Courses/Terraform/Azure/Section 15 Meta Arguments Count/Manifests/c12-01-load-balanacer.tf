# Resource-1: Create Public IP Address for Azure Load Balancer

resource "azurerm_public_ip" "web_lb_publicip"{
    name = "${local.resource_name_prefix}-${var.web_lb_name}-publicip"
    resource_group_name = azurerm_resource_group.myrg.name
    location = azurerm_resource_group.myrg.location
    allocation_method = "Static"
    sku = "Standard"
    tags = local.common_tags
}

# Resource-2: Create Azure Standard Load Balancer

resource "azurerm_lb" "web_lb" {
    name = "${local.resource_name_prefix}-${var.web_lb_name}"
    resource_group_name = azurerm_resource_group.myrg.name
    location = azurerm_resource_group.myrg.location
    sku = "Standard"

    frontend_ip_configuration {
        name = "${local.resource_name_prefix}-${var.web_lb_name}-ip_config"
        public_ip_address_id = azurerm_public_ip.web_lb_publicip.id
    }
}
# Resource-3: Create LB Backend Pool
resource "azurerm_lb_backend_address_pool" "web_lb_backend_pool" {
    loadbalancer_id = azurerm_lb.web_lb.id
    name = "${local.resource_name_prefix}-${var.web_lb_name}-backendpool"
}

# Resource-4: Create LB Probe

resource "azurerm_lb_probe" "web_lb_tcp80_probe"{
    loadbalancer_id = azurerm_lb.web_lb.id
    name = "http-80-probe"
    protocol = "Tcp"
    port = 80
    probe_threshold = 3
    interval_in_seconds = 10
}
# Resource-5: Create LB Rule

resource "azurerm_lb_rule" "web_lb_rules"{
    loadbalancer_id = azurerm_lb.web_lb.id
    name = "${azurerm_lb.web_lb.name}-rule-80"
    protocol = "Tcp"
    frontend_port = 80
    backend_port = 80
    frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
    backend_address_pool_ids = [ azurerm_lb_backend_address_pool.web_lb_backend_pool.id ]
    probe_id = azurerm_lb_probe.web_lb_tcp80_probe.id
    disable_outbound_snat = true
}
# Resource-6: Associate Network Interface and Standard Load Balancer

resource "azurerm_network_interface_backend_address_pool_association" "web_lb_nic_be_association"{
    count = var.web_linuxvm_instance_count
    network_interface_id = element(azurerm_network_interface.web_linuxvm_nic[*].id, count.index)
    # Alternative approach:
    # network_interface_id = azurerm_network_interface.web_linuxvm_nic[count.index].id 
    ip_configuration_name = azurerm_network_interface.web_linuxvm_nic[count.index].ip_configuration[0].name
    backend_address_pool_id = azurerm_lb_backend_address_pool.web_lb_backend_pool.id
}