terraform{
    required_version = ">=1.0.0"
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = ">=2.0"
        }
    }
}

provider "azurerm" {
    features{}
    subscription_id = "8a58d831-ec06-4123-aecf-cdbf9b7297ee"
}
provider "azurerm" {
    features {
      virtual_machine {
        delete_os_disk_on_deletion = false
      }
    }
    alias = "provider2-westus"
    subscription_id = "8a58d831-ec06-4123-aecf-cdbf9b7297ee"    
  
}

resource "azurerm_resource_group" "myrg1" {
  name="myrg1"
  location = "eastus"
}

resource "azurerm_resource_group" "myrg2" {
  name="myrg2"
  location = "west us"
  provider = azurerm.provider2-westus
}