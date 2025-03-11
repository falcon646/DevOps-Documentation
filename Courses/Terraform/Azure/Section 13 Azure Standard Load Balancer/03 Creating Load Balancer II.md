
### **Creating the Health Probe**

A health probe is required to monitor the availability of backend VMs.

```hcl
resource "azurerm_lb_probe" "web_lb_probe" {
  name            = "tcp-probe"
  loadbalancer_id = azurerm_lb.web_lb.id
  protocol        = "Tcp"
  port           = 80
}
```

- **Name**: `"tcp-probe"`, as it checks over TCP.
- **Load Balancer Association**: Ensures that the probe is linked.
- **Protocol**: Set to `"Tcp"` to check connectivity.
- **Port**: `"80"` since it is a web-based service.



### **Creating the Load Balancer Rule**

The load balancer rule connects the frontend IP with the backend pool.

```hcl
resource "azurerm_lb_rule" "web_lb_rule_app1" {
  name                        = "web-app1-rule"
  loadbalancer_id             = azurerm_lb.web_lb.id
  frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
  backend_address_pool_id     = azurerm_lb_backend_address_pool.web_lb_backend_pool.id
  probe_id                    = azurerm_lb_probe.web_lb_probe.id
  protocol                    = "Tcp"
  frontend_port               = 80
  backend_port                = 80
}
```

- **Name**: `"web-app1-rule"` for application 1.
- **Frontend IP Configuration**: References the first (`[0]`) frontend IP.
- **Backend Pool Association**: Connects with the `web_lb_backend_pool`.
- **Probe Association**: Uses `web_lb_probe` to monitor backend health.
- **Protocol & Ports**: `"Tcp"` with frontend and backend port `80`.


### **Associating the Load Balancer with Virtual Machines**

Finally, the virtual machines are added to the backend pool.

```hcl
resource "azurerm_network_interface_backend_address_pool_association" "web_nic_lb_associate" {
  network_interface_id    = azurerm_network_interface.web_linuxvm_nic.id
  ip_configuration_name   = azurerm_network_interface.web_linuxvm_nic.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.web_lb_backend_pool.id
}
```

- **Network Interface ID**: Uses `web_linuxvm_nic` ID.
- **IP Configuration**: Selects the primary IP configuration (`[0]`).
- **Backend Pool Association**: Links the VM NIC with the `web_lb_backend_pool`.



### **Summary**

| Resource | Terraform Resource | Purpose |
|----------|--------------------|---------|
| **Public IP** | `azurerm_public_ip` | Provides an external IP for the Load Balancer. |
| **Load Balancer** | `azurerm_lb` | Manages inbound traffic distribution. |
| **Backend Pool** | `azurerm_lb_backend_address_pool` | Defines backend VMs to receive traffic. |
| **Health Probe** | `azurerm_lb_probe` | Checks backend VM health. |
| **Load Balancer Rule** | `azurerm_lb_rule` | Connects frontend and backend configurations. |
| **NIC Association** | `azurerm_network_interface_backend_address_pool_association` | Associates VMs with backend pool. |

This Terraform configuration ensures a **fully functional Standard Load Balancer** setup in **Azure**, distributing traffic efficiently while maintaining high availability.