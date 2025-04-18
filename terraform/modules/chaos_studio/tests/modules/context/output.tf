output "rg" {
  value = data.azurerm_resource_group.rg
}

output "vnet" {
  value = data.azurerm_virtual_network.vnet
}

output "pe_subnet" {
  value = data.azurerm_subnet.pe_subnet
}

output "client_config" {
  value = data.azurerm_client_config.current
}