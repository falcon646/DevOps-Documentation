# business division
variable "business_division" {
    description = "Business Division of the company"
    type  = String
    default = "sap"
}

# environment variable
variable "environment" {
    description = "Environment variable used as a prefix for every resource"
    type        = string
    default     = "dev"
}

# resource group variable
variable "resource_group_name"{
    description = "resource group name"
    type = String
    default = "rg-default"
}

# resource group location
variable "resource_group_location" {
  description = "Region in which Azure resources are to be created"
  type        = string
  default     = "eastus2"
}