terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0.0"
    }
    azapi = {
      source = "Azure/azapi"
      version = "2.3.0"
    }
  }
}

resource "azapi_resource" "register_target" {
  for_each = var.targets
  type                    = "Microsoft.Chaos/targets@2024-01-01"
  name                    = each.value.target_type
  location                = var.location
  parent_id               = each.key
  response_export_values  = ["*"]
  ignore_missing_property = true
  ignore_casing           = true
  body                    = {
    properties = {}
  }
}

# resource azurerm_chaos_studio_target "this" {
#   location           = var.location
#   target_resource_id = var.target_id
#   target_type        = var.target_type
# }