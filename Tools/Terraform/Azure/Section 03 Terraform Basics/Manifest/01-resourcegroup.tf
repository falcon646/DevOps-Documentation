# settings block
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.16.0"
    }
  }
}

# provider block
provider "azurerm"{
    features{}
    subscription_id = "8a58d831-ec06-4123-aecf-cdbf9b7297ee"
}

# create resoure group
resource "azurerm_resource_group" "my_demo_rg1" {
    location = "eastus"
    name = "my_demo_rg1"
}