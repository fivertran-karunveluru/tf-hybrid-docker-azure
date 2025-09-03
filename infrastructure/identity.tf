# Managed Identity for the Fivetran Agent VM
resource "azurerm_user_assigned_identity" "fivetran_agent_identity" {
  name                = "mi-${var.environment}-${var.project_name}"
  resource_group_name = data.azurerm_resource_group.main_rg.name
  location            = data.azurerm_resource_group.main_rg.location

  tags = local.common_tags
}
