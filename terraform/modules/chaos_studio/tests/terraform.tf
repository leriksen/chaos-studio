terraform {
  required_version = "~>1.10.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 4.0.0"
    }
    azapi = {
      source = "Azure/azapi"
      version = "2.3.0"
    }
  }

  # cloud {
  #   organization = "leriksen-experiment"
  #   hostname     = "app.terraform.io"
  # }
  backend "local" {
    path = "./terraform.tfstate"
  }
}
