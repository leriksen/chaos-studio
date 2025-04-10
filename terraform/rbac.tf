resource "azapi_resource" "cstc" {
  type                    = "Microsoft.Authorization/roleAssignments@2022-04-01"
  name                    = uuid()
  parent_id               = azurerm_network_security_group.nsg.id
  response_export_values  = ["*"]
  ignore_missing_property = true
  ignore_casing           = true
  body                    = {
    properties = {
      "roleDefinitionId" = "/subscriptions/2884ad0b-0ac1-4f07-a315-cba72baeec5a/providers/Microsoft.Authorization/roleDefinitions/59a618e3-3c9a-406e-9f03-1a20dd1c55f1",
      "principalId"      = data.azurerm_client_config.current.client_id,
      "principalType"    = "ServicePrincipal"
    }
  }
}