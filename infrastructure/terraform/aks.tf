resource "azurerm_kubernetes_cluster" "velora" {
  name                = "velora-dev-aks"
  location            = azurerm_resource_group.velora.location
  resource_group_name = azurerm_resource_group.velora.name
  dns_prefix          = "velora-dev"


oms_agent {
  log_analytics_workspace_id = azurerm_log_analytics_workspace.velora.id
}

  sku_tier = "Free"

  default_node_pool {
    name           = "system"
    node_count     = 1
    vm_size        = "standard_d2as_v6"
    vnet_subnet_id = azurerm_subnet.aks.id
  }
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    service_cidr   = "10.30.0.0/16"
    dns_service_ip = "10.30.0.10"
  }

  depends_on = [
    azurerm_role_assignment.aks_network_contributor
  ]

  role_based_access_control_enabled = true

azure_active_directory_role_based_access_control {
  azure_rbac_enabled = false
  tenant_id = var.tenant_id
}
  tags = {
    environment = "dev"
    project     = "velora"
  }
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.velora.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.velora.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = azurerm_subnet.aks.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_user_assigned_identity" "aks" {
  name                = "velora-dev-aks-identity"
  location            = azurerm_resource_group.velora.location
  resource_group_name = azurerm_resource_group.velora.name
}

resource "azurerm_role_assignment" "github_aks_user" {
  scope                = azurerm_kubernetes_cluster.velora.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = var.github_actions_principal_id
}