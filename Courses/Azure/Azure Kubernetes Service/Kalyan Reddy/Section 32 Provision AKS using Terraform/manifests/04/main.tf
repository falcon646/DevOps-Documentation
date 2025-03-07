terraform {
    required_providers {
        azurerm = {
        source  = "hashicorp/azurerm"
        version = "4.21.0"
        }
    }
}

provider "azurerm" {
    features {}
    subscription_id = "xxxx"
}


resource "azurerm_resource_group" "aks_rg2" {
  name     = "AKS-RG2-TF"
  location = "East US"
}