# Data source for existing Virtual Network
data "azurerm_virtual_network" "existing_vnet" {
  name                = local.environment_config[var.environment].vnet_name
  resource_group_name = local.environment_config[var.environment].resource_group
}

# Data source for existing Subnet
data "azurerm_subnet" "existing_subnet" {
  name                 = local.environment_config[var.environment].subnet_name
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name  = data.azurerm_virtual_network.existing_vnet.resource_group_name
}

# Public IP for the VM
resource "azurerm_public_ip" "fivetran_agent_pip" {
  name                = "pip-${var.project_name}-${var.environment}-fivetran-agent"
  resource_group_name = data.azurerm_resource_group.main_rg.name
  location            = data.azurerm_resource_group.main_rg.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-pip"
  })
}

# Network Interface for the VM
resource "azurerm_network_interface" "fivetran_agent_nic" {
  name                = "nic-${var.project_name}-${var.environment}-fivetran-agent"
  location            = data.azurerm_resource_group.main_rg.location
  resource_group_name = data.azurerm_resource_group.main_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.existing_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.fivetran_agent_pip.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-nic"
  })

  depends_on = [
    azurerm_public_ip.fivetran_agent_pip
  ]
}
