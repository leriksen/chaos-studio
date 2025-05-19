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
  for_each                = var.service_targets
  type                    = "Microsoft.Chaos/targets@2024-01-01"
  name                    = each.value.target_type
  location                = var.location
  parent_id               = each.value.target_id
  response_export_values  = ["*"]
  ignore_missing_property = true
  ignore_casing           = true
  body                    = each.value.cspa != null ? {
    properties = {
      subnets = each.value.cspa
    }
  } : {
    properties = {}
  }
}

resource "azapi_resource" "register_capability" {
  for_each = toset(local.target_capabilties)

  type                    = "Microsoft.Chaos/targets/capabilities@2024-01-01"
  name                    = split("::", each.value)[1]
  parent_id               = azapi_resource.register_target[split("::", each.value)[0]].id
  response_export_values  = ["*"]
  ignore_missing_property = true
  ignore_casing           = true
  body                    = {}
}
