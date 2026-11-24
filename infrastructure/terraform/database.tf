resource "azurerm_postgresql_flexible_server" "velora" {
  name                = "velora-db-dev"
  resource_group_name = azurerm_resource_group.velora.name
  location            = azurerm_resource_group.velora.location

  version    = "16"
  sku_name   = "B_Standard_B1ms"
  storage_mb = 32768
  zone = "1"

  administrator_login    = "veloraadmin"
  administrator_password = var.postgresql_admin_password

  delegated_subnet_id = azurerm_subnet.database.id
  private_dns_zone_id = azurerm_private_dns_zone.postgresql.id

  public_network_access_enabled = false

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.postgresql
  ]

  tags = {
    environment = "dev"
    project     = "velora"
  }
}


resource "azurerm_postgresql_flexible_server_database" "velora" {
  name      = "velora"
  server_id = azurerm_postgresql_flexible_server.velora.id

  charset   = "UTF8"
  collation = "en_US.utf8"
}
