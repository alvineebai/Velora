resource "azurerm_container_registry" "velora" {
  name                = "veloradevregistry"
  resource_group_name = azurerm_resource_group.velora.name
  location            = azurerm_resource_group.velora.location

  sku           = "Basic"
  admin_enabled = false

  tags = {
    environment = "dev"
    project     = "velora"
  }
}

data "azuread_service_principal" "github_actions" {
  client_id = "b19c309c-31a0-4ab7-93b6-7c66a5df89ab"
}

resource "azurerm_role_assignment" "github_acr_push" {
  scope                = azurerm_container_registry.velora.id
  role_definition_name = "AcrPush"
  principal_id         = var.github_actions_principal_id
}