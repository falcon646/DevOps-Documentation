terraform {
    required_version = ">=1.0.0"
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = ">=4.0"
        }
        random = {
            source = "hashicorp/random"
            version = "3.6.3"
        }
    }
}

provider "azurerm" {
  features{}
  subscription_id = "8a58d831-ec06-4123-aecf-cdbf9b7297ee"
}