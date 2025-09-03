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

variable "vm_size" {
  description = "VM Size"
  type        = string
  default     = "Standard_D4s_v3"
  validation {
    condition     = contains(["Standard_D2s_v3", "Standard_D4s_v3", "Standard_D8s_v3", "Standard_D16s_v3", "Standard_B2s"], var.vm_size)
    error_message = "VM size must be one of: Standard_D2s_v3, Standard_D4s_v3, Standard_D8s_v3, Standard_D16s_v3, Standard_B2s."
  }
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "fivetran"
}

variable "admin_ssh_key" {
  description = "SSH public key for VM access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "my_ip" {
  description = "IP Address of my computer"
  type        = string
  default     = "xx.xx.xx.xx/32"
}

variable "health_check_port" {
  description = "Port number to use for accessing agent health"
  type        = number
  default     = 8090
}

variable "external_id" {
  description = "ExternalId for the Fivetran Agent"
  type        = string
  default     = "phalanx_xxxxx"
}

variable "agent_token" {
  description = "AgentToken for the Fivetran Agent"
  type        = string
  default     = "ZmxvdGlsbGFfeXVtbXk6ZWVtZkZORDN1aWxxxxxxxxxxxxxxxxxxxxxx"
  sensitive   = true
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
  default     = "2025-08-31"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "subscription_id" {
  description = "Azure subscription ID. Leave empty to use default subscription"
  type        = string
  default     = "e9e63ed6-f43a-49af-b534-67cbcd7a2921"
}

variable "resource_group_name" {
  description = "Name of the resource group for the infrastructure"
  type        = string
  default     = "csg-sa-kveluru"
}


