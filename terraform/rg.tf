resource "azurerm_resource_group" "rg" {
  location = module.globals.location
  name     = "chaos-studio"
}