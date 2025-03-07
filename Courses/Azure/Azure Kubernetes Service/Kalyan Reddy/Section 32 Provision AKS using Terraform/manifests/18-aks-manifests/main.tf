# We will define 
# 1. Terraform Settings Block
# 1. Required Version Terraform
# 2. Required Terraform Providers
# 3. Terraform Remote State Storage with Azure Storage Account (last step of this section)
# 2. Terraform Provider Block for AzureRM
# 3. Terraform Resource Block: Define a Random Pet Resource


# 1. Terraform Settings Block

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
        azuread = {
            source  = "hashicorp/azuread"
            version = "~> 3.0"
        }
    }

    # Configure Terraform State Storage
    # backend "azurerm" {
    #     resource_group_name   = "terraform-storage-rg"
    #     storage_account_name  = "xxxx"
    #     container_name        = "prodtfstate"
    #     key                   = "terraform.tfstate"
    # }
}

# 2. Terraform Provider Block for AzureRM
provider "azurerm" {
  subscription_id = "8a58d831-ec06-4123-aecf-cdbf9b7297ee"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# 3. Terraform Resource Block: Define a Random Pet Resource
resource "random_pet" "aksrandom" {

}

provider "azuread" {
  
}