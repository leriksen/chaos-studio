# resource "azurerm_role_assignment" "cs_target_contrib" {
#   principal_id         = data.azurerm_client_config.current.client_id
#   scope                = azurerm_resource_group.rg.id
#   role_definition_name = "Chaos Studio Target Contributor"
# }

module "chaos_studio" {
  source = "./modules/chaos_studio"

  depends_on = [
    azurerm_network_security_group.nsg,
    azurerm_key_vault.kv,
    azurerm_linux_virtual_machine.vm01,
  ]

  location = azurerm_resource_group.rg.location

  service_targets = {
    (azurerm_network_security_group.nsg.name) = {
      target_id   = azurerm_network_security_group.nsg.id
      target_type = "Microsoft-NetworkSecurityGroup"
      capabilities = [
        "SecurityRule-1.1",
        "SecurityRule-1.0",
      ]
      cspa = {
        name = azurerm_network_security_group.nsg.name
        subnets = {
          containerSubnetId = azurerm_subnet.aci.id
          relaySubnetId     = azurerm_subnet.ar.id
        }
      }
    }
    (azurerm_key_vault.kv.name) = {
      target_id   = azurerm_key_vault.kv.id
      target_type = "Microsoft-KeyVault"
      capabilities = [
        "DenyAccess-1.0",
        "DisableCertificate-1.0",
        "IncrementCertificateVersion-1.0",
        "UpdateCertificatePolicy-1.0"
      ]
    }
    (azurerm_linux_virtual_machine.vm01.name) = {
      target_id   = azurerm_linux_virtual_machine.vm01.id
      target_type = "Microsoft-VirtualMachine"
      capabilities = [
        "Redeploy-1.0"
      ]
    }
  }
}