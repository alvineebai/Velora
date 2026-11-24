resource "azurerm_virtual_network" "velora" {
  name                = "velora-dev-vnet"
  address_space       = ["10.20.0.0/16"]
  location            = azurerm_resource_group.velora.location
  resource_group_name = azurerm_resource_group.velora.name

  tags = {
    environment = "dev"
    project     = "velora"
  }
}

resource "azurerm_subnet" "aks" {
  name                 = "velora-dev-aks-subnet"
  resource_group_name  = azurerm_resource_group.velora.name
  virtual_network_name = azurerm_virtual_network.velora.name
  address_prefixes     = ["10.20.0.0/22"]
}

resource "azurerm_subnet" "database" {
  name                 = "velora-dev-db-subnet"
  resource_group_name  = azurerm_resource_group.velora.name
  virtual_network_name = azurerm_virtual_network.velora.name
  address_prefixes     = ["10.20.4.0/24"]

  delegation {
    name = "postgresql-delegation"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

