
resource "azurerm_log_analytics_workspace" "velora" {
  name                = "velora-dev-logs"
  location            = azurerm_resource_group.velora.location
  resource_group_name = azurerm_resource_group.velora.name

  sku               = "PerGB2018"
  retention_in_days = 30

  tags = {
    environment = "dev"
    project     = "velora"
  }
}


resource "azurerm_monitor_action_group" "velora" {
  name                = "velora-dev-alerts"
  resource_group_name = azurerm_resource_group.velora.name
  short_name          = "velora"
  enabled             = true

  tags = {
    environment = "dev"
    project     = "velora"
  }
}
