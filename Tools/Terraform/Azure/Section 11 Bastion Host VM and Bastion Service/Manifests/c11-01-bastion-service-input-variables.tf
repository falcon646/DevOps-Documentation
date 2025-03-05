# bastion service realted input vars
variable "bastion_service_subnet_name" {
    description = "Bastion Service Subnet Name"
    default = "AzureBastionSubnet" // should not be changed
}

variable "bastion_service_address_prefixes" {
    description = "Bastion Service Address Prefixes"
    default = ["10.0.101.0/27"]
}