# This file serves as the main entry point for the Terraform configuration
# All resources are defined in their respective files:
# - identity.tf: Managed Identity
# - role-assignments.tf: Role assignments for the managed identity
# - network.tf: Virtual Network and Subnet configuration
# - security.tf: Network Security Group configuration
# - vm.tf: Virtual Machine configuration
# - outputs.tf: Output values
# - variables.tf: Input variables
# - locals.tf: Local values and environment mappings
# - providers.tf: Provider configuration
# - versions.tf: Terraform and provider version requirements

# Data source for existing Resource Group
# This resource group must already exist in Azure before running this Terraform configuration
# If you need to import an existing resource group, use:
# terraform import data.azurerm_resource_group.main_rg /subscriptions/{subscription_id}/resourceGroups/{resource_group_name}
data "azurerm_resource_group" "main_rg" {
  name = var.resource_group_name
}


# The configuration is designed to be deployed across multiple environments
# (dev, qa, stg, prd, internal-sales) with environment-specific
# VNet and subnet configurations defined in locals.tf
