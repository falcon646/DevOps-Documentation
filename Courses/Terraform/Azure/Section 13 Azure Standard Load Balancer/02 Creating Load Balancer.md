# Creating Load Balancer using Terraform

This section focuses on writing Terraform configuration for implementing an **Azure Standard Load Balancer**.

To create a Load bslancer we would need to create the folllwing Reources
- Resource-1: Create Public IP Address for Azure Load Balancer
- Resource-2: Create Azure Standard Load Balancer
- Resource-3: Create LB Backend Pool
- Resource-4: Create LB Probe
- Resource-5: Create LB Rule
- Resource-6: Associate Network Interface and Standard Load Balancer

We would be resuing the configuration files from the previous module , excet the `Bastion service` resources

The setup begins with **step-01**:  
**c12-00-load_balancer_vars.tf** → Defines the necessary input variables.  
**c12-01-load-balanacer.tf** → Creates multiple Terraform resources for the load balancer.

# 

### **Resources Required for Load Balancer Deployment**
The **Azure Standard Load Balancer** and its association with virtual machines require the following Terraform resources:

1. **Public IP for Load Balancer**
2. **Load Balancer Base Resource**
3. **Backend Pool**
4. **Health Probe**
5. **Load Balancer Rule**
6. **Backend Pool Association with Virtual Machines**

Each of these resources is created sequentially.

# 

### **Creating a Public IP for Load Balancer**
```hcl
resource "azurerm_public_ip" "web_lb_public_ip" {
  name                = "${local.resource_name_prefix}-lbpublicip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                = "Standard"

  tags = local.common_tags
}
```
- **Allocation Method** → Static  
- **SKU Tier** → Standard  
- **Tagging** → Uses common tags from `local.common_tags`

# 

### **Creating the Azure Load Balancer**
```hcl
resource "azurerm_lb" "web_lb" {
  name                = "${local.resource_name_prefix}-web-lb"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                = "Standard"

  frontend_ip_configuration {
    name                 = "web-lb-publicip-1"
    public_ip_address_id = azurerm_public_ip.web_lb_public_ip.id
  }
}
```
- Associates the **frontend IP configuration** with the previously created **public IP**.



### **Creating the Backend Address Pool**
```hcl
resource "azurerm_lb_backend_address_pool" "web_backend_pool" {
  name            = "web-backend"
  loadbalancer_id = azurerm_lb.web_lb.id
}
```
- Defines a **backend pool** for the web tier.  
- Associates the **backend pool** with the **Load Balancer**.
