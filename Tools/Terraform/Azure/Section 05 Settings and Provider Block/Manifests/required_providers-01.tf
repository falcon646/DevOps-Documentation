terraform{
    required_version = ">=1.0.0"
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            # version = "~>2.64" # for production
            # version = "2.60"
            # version = ">=2.0 , <=2.60"
             version = ">=2.0 , <=2.64"
        }
    }
}

provider "azurerm" {
    features{}
}