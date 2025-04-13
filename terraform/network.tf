resource azurerm_virtual_network "vnet" {
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  name                = format("%s-vnet01", azurerm_resource_group.rg.name)
  resource_group_name = azurerm_resource_group.rg.name
}

resource azurerm_subnet "snet" {
  address_prefixes     = [cidrsubnet(tolist(azurerm_virtual_network.vnet.address_space)[0], 8, 0)]
  name                 = format("%s-snet01", azurerm_virtual_network.vnet.name)
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource azurerm_subnet "pe" {
  address_prefixes     = [cidrsubnet(tolist(azurerm_virtual_network.vnet.address_space)[0], 8, 1)]
  name                 = format("%s-pe01", azurerm_virtual_network.vnet.name)
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

# for PE support in ACXS - inject Azure Container Instance
resource azurerm_subnet "aci" {
  address_prefixes     = [cidrsubnet(tolist(azurerm_virtual_network.vnet.address_space)[0], 8, 2)]
  name                 = format("%s-aci01", azurerm_virtual_network.vnet.name)
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  delegation {
    name = "acxs-aci"
    service_delegation {
      name = "Microsoft.ContainerInstance/containerGroups"
    }
  }
  lifecycle {
    ignore_changes = [
      delegation["service_delegation.actions"]
    ]
  }
}

# for PE support in ACXS - inject Azure Relay
resource azurerm_subnet "ar" {
  address_prefixes     = [cidrsubnet(tolist(azurerm_virtual_network.vnet.address_space)[0], 8, 3)]
  name                 = format("%s-ar01", azurerm_virtual_network.vnet.name)
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}
#
# resource azurerm_subnet "bastion" {
#   address_prefixes     = [cidrsubnet(tolist(azurerm_virtual_network.vnet.address_space)[0], 8, 2)]
#   name                 = "AzureBastionSubnet"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
# }

resource azurerm_network_security_group "nsg" {
  location            = azurerm_resource_group.rg.location
  name                = format("%s-nsg01", azurerm_subnet.snet.name)
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "snet-nsg-assoc" {
  network_security_group_id = azurerm_network_security_group.nsg.id
  subnet_id                 = azurerm_subnet.snet.id
}

resource "azurerm_subnet_network_security_group_association" "pe-nsg-assoc" {
  network_security_group_id = azurerm_network_security_group.nsg.id
  subnet_id                 = azurerm_subnet.pe.id
}