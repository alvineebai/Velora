resource "azurerm_network_security_group" "database" {
  name                = "velora-dev-db-nsg"
  location            = azurerm_resource_group.velora.location
  resource_group_name = azurerm_resource_group.velora.name

  tags = {
    environment = "dev"
    project     = "velora"
  }
}

resource "azurerm_subnet_network_security_group_association" "database" {
  subnet_id                 = azurerm_subnet.database.id
  network_security_group_id = azurerm_network_security_group.database.id
}

resource "azurerm_network_security_rule" "allow_aks_to_database" {
  name      = "allow-aks-to-postgresql"
  priority  = 100
  direction = "Inbound"
  access    = "Allow"
  protocol  = "Tcp"

  source_port_range      = "*"
  destination_port_range = "5432"

  source_address_prefix      = "10.20.0.0/22"
  destination_address_prefix = "10.20.4.0/24"

  resource_group_name         = azurerm_resource_group.velora.name
  network_security_group_name = azurerm_network_security_group.database.name
}


resource "azurerm_network_security_rule" "deny_other_database_access" {
  name      = "deny-other-postgresql-access"
  priority  = 200
  direction = "Inbound"
  access    = "Deny"
  protocol  = "Tcp"

  source_port_range      = "*"
  destination_port_range = "5432"

  source_address_prefix      = "VirtualNetwork"
  destination_address_prefix = "10.20.4.0/24"

  resource_group_name         = azurerm_resource_group.velora.name
  network_security_group_name = azurerm_network_security_group.database.name
}
