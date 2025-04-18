resource "azurerm_key_vault" "kv" {
  location                      = var.location
  name                          = "validate-target-akv"
  resource_group_name           = var.rg
  sku_name                      = "premium"
  tenant_id                     = var.tenant_id
  public_network_access_enabled = false
  purge_protection_enabled      = false
  enable_rbac_authorization     = true
}

resource "azurerm_private_endpoint" "pe" {
  location            = var.location
  name                = "validate-pe01"
  resource_group_name = var.rg
  subnet_id           = var.pe_subnet
  private_service_connection {
    is_manual_connection           = false
    name                           = "psc01"
    private_connection_resource_id = azurerm_key_vault.kv.id
    subresource_names              = [
      "vault"
    ]
  }
}