# virtual network name
variable "vnet_name"{
   type = string
   description = "virtual network name"
   default = "vnet-default"
}
# virtual network address space
variable "vnet_address_space" {
   type = list(string)
   description = "virtual network address space"
   default = [ "10.0.0.0/16" ]
}

# web subnet name
variable "web_subnet_name" {
   type = string
   description = "virtual network web subnet name"
   default = "websubnet-default"
}

# web subnet address space
variable "web_subnet_address" {
   type = list(string)
   description = "web subnet address space"
   default = [ "10.0.1.0/24" ]
}

# App Subnet Name
variable "app_subnet_name" {
  description = "Virtual Network App Subnet Name"
  type = string
  default = "appsubnet"
}
# App Subnet Address Space
variable "app_subnet_address" {
  description = "Virtual Network App Subnet Address Spaces"
  type = list(string)
  default = ["10.0.11.0/24"]
}

# Database Subnet Name
variable "db_subnet_name" {
  description = "Virtual Network Database Subnet Name"
  type = string
  default = "dbsubnet"
}
# Database Subnet Address Space
variable "db_subnet_address" {
  description = "Virtual Network Database Subnet Address Spaces"
  type = list(string)
  default = ["10.0.21.0/24"]
}

# Bastion / Management Subnet Name
variable "bastion_subnet_name" {
  description = "Virtual Network Bastion Subnet Name"
  type = string
  default = "bastionsubnet"
}
# Bastion / Management Subnet Address Space
variable "bastion_subnet_address" {
  description = "Virtual Network Bastion Subnet Address Spaces"
  type = list(string)
  default = ["10.0.100.0/24"]
}