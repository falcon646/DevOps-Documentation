### **Terraform Configuration for Azure Standard Load Balancer Inbound NAT Rules**  

- The **Admin User** will SSH into the **Web VM** via the **Load Balancer's Public IP** using **port 1022**.  
- The **Azure Load Balancer** will forward the request from **port 1022 (frontend)** to **port 22 (backend)** of the Web VM.  
- This setup allows secure access to Web VMs inside a private subnet without exposing them directly to the internet.  



### **Terraform Resources**  

The configuration involves two main resources:  

1. **`azurerm_lb_nat_rule`** – Defines the NAT rule for port forwarding.  
2. **`azurerm_network_interface_nat_rule_association`** – Associates the NAT rule with the Web VM's **network interface**.  



### **Terraform Configuration**  

#### **1. Define the Load Balancer NAT Rule (`azurerm_lb_nat_rule`)**  

```hcl
resource "azurerm_lb_nat_rule" "web_lb_nat_rule_22" {
  name                           = "ssh-1022-VM-22"
  resource_group_name            = azurerm_resource_group.web_rg.name
  loadbalancer_id                = azurerm_lb.web_lb.id
  protocol                       = "Tcp"
  frontend_port                  = 1022
  backend_port                   = 22
  frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
}
```

##### **Explanation:**  
- The **NAT rule** is created with the name **"ssh-1022-VM-22"**.  
- **Frontend Port (1022)**: External SSH requests will be sent to this port on the Load Balancer’s public IP.  
- **Backend Port (22)**: Internally, the Load Balancer will forward requests to the Web VM’s **SSH port (22)**.  
- **Frontend IP Configuration**: References the **public IP** of the Load Balancer.  



#### **2. Associate the NAT Rule with the Web VM’s Network Interface (`azurerm_network_interface_nat_rule_association`)**  

```hcl
resource "azurerm_network_interface_nat_rule_association" "web_nic_nat_rule_associate" {
  network_interface_id   = azurerm_network_interface.web_linuxvm_nic.id
  ip_configuration_name  = azurerm_network_interface.web_linuxvm_nic.ip_configuration[0].name
  nat_rule_id            = azurerm_lb_nat_rule.web_lb_nat_rule_22.id
}
```

##### **Explanation:**  
- The **network interface** of the Web VM is linked to the **NAT rule**.  
- This ensures SSH connections made to **port 1022** on the Load Balancer **reach the Web VM's port 22**.  