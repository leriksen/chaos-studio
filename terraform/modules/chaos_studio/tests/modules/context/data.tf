data azurerm_resource_group "rg" {
  name = var.resource_group
}

data azurerm_virtual_network "vnet" {
  resource_group_name = data.azurerm_resource_group.rg.name
  name                = format("%s-vnet01", data.azurerm_resource_group.rg.name)
}

data azurerm_subnet "pe_subnet" {
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
  name                 = format("%s-pe01", data.azurerm_virtual_network.vnet.name)
}

data azurerm_client_config "current" {}