# Backend Infrastructure Resources
# This file creates the Storage Account and Table Storage needed for remote state management

# Resource Group for Backend Infrastructure
resource "azurerm_resource_group" "backend_rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Name        = var.resource_group_name
    Purpose     = "Terraform remote state storage"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    owner       = var.owner_name
    team        = var.team_name
    department  = var.department_name
    expires_on  = var.expires_on
  }
}

# Storage Account for Terraform State
resource "azurerm_storage_account" "terraform_state" {
  name                     = var.terraform_state_storage_account
  resource_group_name      = azurerm_resource_group.backend_rg.name
  location                 = azurerm_resource_group.backend_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  # Enable versioning for state files
  blob_properties {
    versioning_enabled = true
  }

  tags = {
    Name        = var.terraform_state_storage_account
    Purpose     = "Terraform remote state storage"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
    owner       = var.owner_name
    team        = var.team_name
    department  = var.department_name
    expires_on  = var.expires_on
  }
}

# Storage Container for Terraform State
resource "azurerm_storage_container" "terraform_state" {
  name                  = var.terraform_state_container
  storage_account_name  = azurerm_storage_account.terraform_state.name
  container_access_type = "private"
}

# Table Storage for State Locking
resource "azurerm_storage_table" "terraform_state_lock" {
  name                 = var.terraform_state_table
  storage_account_name = azurerm_storage_account.terraform_state.name
}

# Outputs for backend information
output "backend_storage_account" {
  description = "Storage account created for Terraform state"
  value       = azurerm_storage_account.terraform_state.name
}

output "backend_storage_container" {
  description = "Storage container created for Terraform state"
  value       = azurerm_storage_container.terraform_state.name
}

output "backend_table_storage" {
  description = "Table storage created for state locking"
  value       = azurerm_storage_table.terraform_state_lock.name
}

output "backend_resource_group" {
  description = "Resource group created for backend infrastructure"
  value       = azurerm_resource_group.backend_rg.name
}

output "backend_location" {
  description = "Azure region for backend infrastructure"
  value       = azurerm_resource_group.backend_rg.location
}
