resource "azurerm_virtual_network" "vnet" {
  address_space = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  name                = "vnet01"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "snet01" {
  address_prefixes = ["10.0.0.0/24"]
  name                 = "snet01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_network_interface" "nic01" {
  name                  = "nic01"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "public"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.snet01.id
    public_ip_address_id          = azurerm_public_ip.ip01.id
  }
}

resource "azurerm_public_ip" "ip01" {
  location = azurerm_resource_group.rg.location
  name = "ip01"
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method = "Static"
}

resource "azurerm_network_security_group" "nsg01" {
  location            = azurerm_resource_group.rg.location
  name                = "nsg01"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_interface_security_group_association" "nic2nsg" {
  network_interface_id      = azurerm_network_interface.nic01.id
  network_security_group_id = azurerm_network_security_group.nsg01.id
}

resource "azurerm_network_security_rule" "ssh_in" {
  name                        = "ssh_in"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg01.name
}