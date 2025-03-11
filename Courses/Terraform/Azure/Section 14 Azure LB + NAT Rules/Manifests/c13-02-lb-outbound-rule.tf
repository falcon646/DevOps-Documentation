resource "azurerm_lb_outbound_rule" "web_lb-outbount-rule-80" {
  name                    = "OutboundRule"
  loadbalancer_id         = azurerm_lb.web_lb.id
  protocol                = "Tcp"
  backend_address_pool_id = azurerm_lb_backend_address_pool.web_lb_backend_pool.id

  frontend_ip_configuration {
    name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
  }
}