resource "azurerm_resource_group" "velora" {
  name     = "velora-dev-rg"
  location = var.location

  tags = {
    environment = "dev"
    project     = "velora"
  }
}
