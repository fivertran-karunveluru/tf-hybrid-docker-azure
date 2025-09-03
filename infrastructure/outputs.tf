output "agent_vm_id" {
  description = "Fivetran Agent VM ID"
  value       = azurerm_linux_virtual_machine.fivetran_agent_vm.id
}

output "agent_vm_public_ip" {
  description = "Public IP address of the Fivetran Agent VM"
  value       = azurerm_public_ip.fivetran_agent_pip.ip_address
}

output "agent_vm_private_ip" {
  description = "Private IP address of the Fivetran Agent VM"
  value       = azurerm_network_interface.fivetran_agent_nic.private_ip_address
}

output "network_security_group_id" {
  description = "Network Security Group ID for the Fivetran Agent"
  value       = azurerm_network_security_group.fivetran_agent_nsg.id
}

output "managed_identity_principal_id" {
  description = "Managed Identity Principal ID for the Fivetran Agent"
  value       = azurerm_user_assigned_identity.fivetran_agent_identity.principal_id
}

output "managed_identity_client_id" {
  description = "Managed Identity Client ID for the Fivetran Agent"
  value       = azurerm_user_assigned_identity.fivetran_agent_identity.client_id
}



output "resource_group_name" {
  description = "Name of the resource group"
  value       = data.azurerm_resource_group.main_rg.name
}
