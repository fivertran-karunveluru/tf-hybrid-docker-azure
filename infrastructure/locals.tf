locals {
  # Environment mappings
  environment_config = {
    internal-sales = {
      vnet_name     = "vnet-kveluru-docker-agent"
      subnet_name   = "subnet-kveluru-docker-agent-public"
      resource_group = "csg-sa-kveluru-docker-hybrid-agent"
    }
    dev = {
      vnet_name     = "vnet-kveluru-docker-agent"
      subnet_name   = "subnet-kveluru-docker-agent-public"
      resource_group = "csg-sa-kveluru-docker-hybrid-agent"
    }
    qa = {
      vnet_name     = "vnet-qa"
      subnet_name   = "subnet-qa-public"
      resource_group = "rg-qa"
    }
    stg = {
      vnet_name     = "vnet-staging"
      subnet_name   = "subnet-staging-public"
      resource_group = "rg-staging"
    }
    prd = {
      vnet_name     = "vnet-production"
      subnet_name   = "subnet-production-public"
      resource_group = "rg-production"
    }
  }

  # Common tags (excluding environment and managed_by which are set by provider default_tags)
  common_tags = {
    owner        = var.owner_name
    team         = var.team_name
    expires_on   = var.expires_on
    department   = var.department_name
  }

}
