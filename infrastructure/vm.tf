# Virtual Machine for Fivetran Agent
resource "azurerm_linux_virtual_machine" "fivetran_agent_vm" {
  name                = "vm-${var.project_name}-${var.environment}-fivetran-agent"
  resource_group_name = data.azurerm_resource_group.main_rg.name
  location            = data.azurerm_resource_group.main_rg.location
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.fivetran_agent_nic.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.admin_ssh_key)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 60
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.fivetran_agent_identity.id]
  }

  custom_data = base64encode(templatefile("${path.module}/user_data.sh", {
    agent_token = var.agent_token
  }))

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-vm"
  })

  depends_on = [
    azurerm_network_interface_security_group_association.fivetran_agent_nsg_association,
    azurerm_role_assignment.vm_contributor,
    azurerm_role_assignment.monitoring_contributor,
    azurerm_role_assignment.reader,
    azurerm_user_assigned_identity.fivetran_agent_identity
  ]
}
