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

locals {
  no_properties = {}
}

resource "azapi_resource" "register_target" {
  for_each                = var.targets
  type                    = "Microsoft.Chaos/targets@2024-01-01"
  name                    = each.value.target_type
  location                = var.location
  parent_id               = each.key
  response_export_values  = ["*"]
  ignore_missing_property = true
  ignore_casing           = true
  body                    = each.value.cspa != null ? {
    properties = {
      subnets = each.value.cspa.subnets
    }
  } : {
    properties = {}
  }
}

locals {
  target_capabilties = flatten(
    [
      for target_id, target_details in var.targets : [
        for capability in target_details.capabilities :
          format("%s::%s", target_id, capability)
      ]
    ]
  )


  target_cspa = flatten(
    [
      for target_id, target_details in var.targets :
        format("%s::%s", target_id, target_details.cspa.name) if target_details.cspa != null
    ]
  )
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

# this is for private linked agent-based experiments
# resource azapi_resource "cspa" {
#   for_each = toset(local.target_cspa)
#
#   type      = "Microsoft.Chaos/privateAccesses@2023-10-27-preview"
#   name      = split("::", each.value)[1]
#   parent_id = split("::", each.value)[0]
#   response_export_values  = ["*"]
#   ignore_missing_property = true
#   ignore_casing           = true
#   schema_validation_enabled = false
#   body      = {
#     location   = var.location
#     properties = {
#       id         = split("::", each.value)[0]
#       name       = split("::", each.value)[1]
#       location   = var.location
#       type       = "Microsoft.Chaos/privateAccesses"
#       resourceId = split("::", each.value)[0]
#     }
#   }
# }
