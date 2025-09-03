provider "azurerm" {
  features {}
  
  # Use subscription_id only if explicitly set
  subscription_id = var.subscription_id != "" ? var.subscription_id : null
}

provider "random" {
  # Random provider for generating unique names
}
