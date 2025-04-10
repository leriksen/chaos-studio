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

resource azurerm_network_security_group "nsg" {
  location            = azurerm_resource_group.rg.location
  name                = format("%s-nsg01", azurerm_subnet.snet.name)
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "subnet-nsg-assoc" {
  network_security_group_id = azurerm_network_security_group.nsg.id
  subnet_id                 = azurerm_subnet.snet.id
}