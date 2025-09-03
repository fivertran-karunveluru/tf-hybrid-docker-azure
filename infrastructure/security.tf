# Network Security Group for the Hybrid Agent VM
resource "azurerm_network_security_group" "fivetran_agent_nsg" {
  name                = "nsg-${var.project_name}-${var.environment}-fivetran-agent"
  location            = data.azurerm_resource_group.main_rg.location
  resource_group_name = data.azurerm_resource_group.main_rg.name

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-nsg"
  })
}

# SSH access from home
resource "azurerm_network_security_rule" "ssh" {
  name                        = "SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.my_ip
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.main_rg.name
  network_security_group_name = azurerm_network_security_group.fivetran_agent_nsg.name
}

# Access to Github repo
resource "azurerm_network_security_rule" "github" {
  name                        = "Github"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "185.0.0.0/8"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.main_rg.name
  network_security_group_name = azurerm_network_security_group.fivetran_agent_nsg.name
}

# Fivetran API
resource "azurerm_network_security_rule" "fivetran_api" {
  name                        = "FivetranAPI"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "35.236.237.87/32"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.main_rg.name
  network_security_group_name = azurerm_network_security_group.fivetran_agent_nsg.name
}

# Fivetran IdP
resource "azurerm_network_security_rule" "fivetran_idp" {
  name                        = "FivetranIdP"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "35.188.225.82/32"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.main_rg.name
  network_security_group_name = azurerm_network_security_group.fivetran_agent_nsg.name
}

# Google Artifactory
resource "azurerm_network_security_rule" "google_artifactory" {
  name                        = "GoogleArtifactory"
  priority                    = 140
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "142.0.0.0/8"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.main_rg.name
  network_security_group_name = azurerm_network_security_group.fivetran_agent_nsg.name
}

# Agent health check
resource "azurerm_network_security_rule" "health_check" {
  name                        = "HealthCheck"
  priority                    = 150
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = var.health_check_port
  source_address_prefix       = var.my_ip
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.main_rg.name
  network_security_group_name = azurerm_network_security_group.fivetran_agent_nsg.name
}

# All outbound traffic
resource "azurerm_network_security_rule" "outbound" {
  name                        = "Outbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.main_rg.name
  network_security_group_name = azurerm_network_security_group.fivetran_agent_nsg.name
}

# Associate NSG with Network Interface
resource "azurerm_network_interface_security_group_association" "fivetran_agent_nsg_association" {
  network_interface_id      = azurerm_network_interface.fivetran_agent_nic.id
  network_security_group_id = azurerm_network_security_group.fivetran_agent_nsg.id
}
