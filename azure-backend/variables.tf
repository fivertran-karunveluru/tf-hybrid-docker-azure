variable "project_name" {
  description = "Name of project for tag and instance names and instance profiles"
  type        = string
  default     = "Docker-Hybrid-Agent"
}

variable "environment" {
  description = "The Azure environment to create resources in (lowercase)"
  type        = string
  default     = "internal-sales"
  validation {
    condition     = contains(["internal-sales", "dev", "qa", "stg", "prd"], var.environment)
    error_message = "Environment must be one of: internal-sales, dev, qa, stg, prd."
  }
}

variable "team_name" {
  description = "Team Name"
  type        = string
  default     = "solution_architects"
}

variable "department_name" {
  description = "Department Name"
  type        = string
  default     = "customer_solutions_group"
}

variable "owner_name" {
  description = "Owner Name"
  type        = string
  default     = "karunakar.veluru@fivetran.com"
}

variable "expires_on" {
  description = "Expires On"
  type        = string
  default     = "2025-09-30"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "subscription_id" {
  description = "Azure subscription ID. Leave empty to use default subscription"
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "Name of the resource group for backend infrastructure"
  type        = string
  default     = "csg-sa-kveluru-docker-hybrid-agent"
}

# Azure Backend Configuration Variables
variable "terraform_state_storage_account" {
  description = "Storage account name for storing Terraform state"
  type        = string
  default     = "csgsakvelurutfstate"
}

variable "terraform_state_container" {
  description = "Storage container name for the Terraform state file"
  type        = string
  default     = "dockeragenttfstate"
}

variable "terraform_state_key" {
  description = "Storage key path for the Terraform state file"
  type        = string
  default     = "hybrid/docker/terraform.tfstate"
}

variable "terraform_state_table" {
  description = "Table storage name for state locking"
  type        = string
  default     = "dockeragenttfstatelock"
}
