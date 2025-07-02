variable "vms" {
  type = map(any)
}

data "azurerm_subnet" "subdata" {
    for_each = var.vms
  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name

}

data "azurerm_key_vault" "secret" {
  for_each = var.vms
  name                = each.value.keyvault_name
  resource_group_name = each.value.resource_group_name

}
data "azurerm_key_vault_secret" "username" {
  for_each = var.vms
  name         = "adminuser1"
  key_vault_id = data.azurerm_key_vault.secret[each.key].id
}

data "azurerm_key_vault_secret" "password" {
  for_each = var.vms
  name         = "adminpassword1"
  key_vault_id = data.azurerm_key_vault.secret[each.key].id
}

resource "azurerm_public_ip" "pip" {
  for_each = var.vms
  name                = each.value.pip_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic" {
  for_each            = var.vms
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = each.value.ip_configuartion
    subnet_id                     = data.azurerm_subnet.subdata[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip[each.key].id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each                        = var.vms
  name                            = each.value.vm_name
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  size                            = each.value.size
  admin_username                  = data.azurerm_key_vault_secret.username[each.key].value
  admin_password                  = data.azurerm_key_vault_secret.password[each.key].value
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nic[each.key].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

source_image_reference {
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-focal"
  sku       = "20_04-lts"
  version   = "latest"
}

}