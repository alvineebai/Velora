resource "azurerm_private_dns_zone" "postgresql" {
  name                = "velora.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.velora.name

  tags = {
    environment = "dev"
    project     = "velora"
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgresql" {
  name                  = "velora-postgres-dns-link"
  resource_group_name   = azurerm_resource_group.velora.name
  private_dns_zone_name = azurerm_private_dns_zone.postgresql.name
  virtual_network_id    = azurerm_virtual_network.velora.id

  registration_enabled = false

  tags = {
    environment = "dev"
    project     = "velora"
  }
}