provider "azurerm" {
  features {}
}

terraform {
  required_version = "~>1.2.4"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.11.0"
    }
  }
  backend "azurerm" {
    key = "terraform.tfstate"
  }
}
