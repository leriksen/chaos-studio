# resource "azurerm_role_assignment" "cs_target_contrib" {
#   principal_id         = data.azurerm_client_config.current.client_id
#   scope                = azurerm_resource_group.rg.id
#   role_definition_name = "Chaos Studio Target Contributor"
# }

module "chaos_studio" {
  source = "./modules/chaos_studio"

  depends_on = [
    # azurerm_role_assignment.cs_target_contrib
  ]

  location = azurerm_resource_group.rg.location

  targets = {
      (azurerm_network_security_group.nsg.id) = {
        target_type = "Microsoft-NetworkSecurityGroup"
        capabilities = [
        ]
      }
  }
}