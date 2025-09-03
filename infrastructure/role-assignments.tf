# Role Assignments for the Fivetran Agent
# These are created after both the managed identity and storage account are created

# Role Assignment: Virtual Machine Contributor (equivalent to EC2 permissions)
resource "azurerm_role_assignment" "vm_contributor" {
  scope                = data.azurerm_resource_group.main_rg.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = azurerm_user_assigned_identity.fivetran_agent_identity.principal_id

  description = "Virtual Machine Contributor role for Fivetran Agent"

  depends_on = [
    azurerm_user_assigned_identity.fivetran_agent_identity
  ]
}

# Role Assignment: Monitoring Contributor (equivalent to CloudWatch access)
resource "azurerm_role_assignment" "monitoring_contributor" {
  scope                = data.azurerm_resource_group.main_rg.id
  role_definition_name = "Monitoring Contributor"
  principal_id         = azurerm_user_assigned_identity.fivetran_agent_identity.principal_id

  description = "Monitoring Contributor role for Fivetran Agent"

  depends_on = [
    azurerm_user_assigned_identity.fivetran_agent_identity
  ]
}

# Role Assignment: Reader (for reading resource metadata)
resource "azurerm_role_assignment" "reader" {
  scope                = data.azurerm_resource_group.main_rg.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.fivetran_agent_identity.principal_id

  description = "Reader role for Fivetran Agent to read resource metadata"

  depends_on = [
    azurerm_user_assigned_identity.fivetran_agent_identity
  ]
}


