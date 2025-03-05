terraform{
  required_version = ">=1.0"
  required_providers{
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
  features {
    
  }
  subscription_id = "8a58d831-ec06-4123-aecf-cdbf9b7297ee"
}

provider random{

}

resource "azurerm_resource_group" "myrg1" {
  location = "east us"
  name = "myrg1"
}

resource "random_string" "myrandom"{
  length = 16
  upper = false
  special = false
}

resource "azurerm_storage_account" "mysa"{
  name = "mysa${random_string.myrandom.id}"
  resource_group_name = azurerm_resource_group.myrg1.name
  location = azurerm_resource_group.myrg1.location
  account_tier = "Standard"
  account_replication_type = "GRS"
  # account_encryption_source = "Microsoft.Storage"
}