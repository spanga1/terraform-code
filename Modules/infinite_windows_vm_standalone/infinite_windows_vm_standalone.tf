# Allocating public IP
resource "azurerm_public_ip" "infinite_vm_public_ip" {
  count               = var.public_ip_name == "" ? 0 : 1
  name                = var.public_ip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.public_ip_address_allocation
}

# Creating NIC
resource "azurerm_network_interface" "infinite_nic" {
  name                          = var.nic_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  enable_accelerated_networking = var.enable_accelerated_networking

  # Allocating private IP
  ip_configuration {
    name                          = var.nic_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
    private_ip_address            = var.private_ip_address
    primary                       = true
    public_ip_address_id          = var.public_ip_name == "" ? null : azurerm_public_ip.infinite_vm_public_ip[0].id
  }

  dynamic "ip_configuration" {
    for_each = var.additional_private_ip_addresses
    content {
      name                          = "${var.computer_name}-additional-nic-${ip_configuration.key}"
      subnet_id                     = var.subnet_id
      private_ip_address_allocation = var.private_ip_address_allocation
      private_ip_address            = ip_configuration.value
    }
  }
}

resource "azurerm_network_interface_security_group_association" "infinte-nic-nsg-association" {
  count                     = var.network_security_group_id == null ? 0 : 1
  network_interface_id      = azurerm_network_interface.infinite_nic.id
  network_security_group_id = var.network_security_group_id

  depends_on = [
    azurerm_network_interface.infinite_nic
  ]
}

# Creating VM
resource "azurerm_windows_virtual_machine" "infinite_windows_vm_standalone" {
  name                = var.computer_name
  resource_group_name = var.resource_group_name
  location            = var.location
  zone                = var.zone
  size                = var.size

  patch_mode                   = var.patch_mode
  enable_automatic_updates     = var.enable_automatic_updates
  admin_username               = var.admin_username
  admin_password               = var.admin_password
  license_type                 = var.license_type 
  network_interface_ids        = [azurerm_network_interface.infinite_nic.id]
  availability_set_id          = var.availability_set_id
  proximity_placement_group_id = var.proximity_placement_group_id

  os_disk {
    storage_account_type = var.os_disk_storage_account_type
    name                 = var.os_disk_name
    caching              = var.os_disk_caching
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_id = var.source_image_id

  dynamic "source_image_reference" {
    for_each = var.source_image_id == null ? [1] : []
    content {
      publisher = var.source_image_reference_publisher
      offer     = var.source_image_reference_offer
      sku       = var.source_image_reference_sku
      version   = var.source_image_reference_version
    }
  }

  tags      = var.tags
  user_data = var.user_data == null ? null : base64encode(var.user_data)
  timezone  = var.timezone

  boot_diagnostics {
    storage_account_uri = var.boot_diagnostics_storage_uri
  }

  depends_on = [
    azurerm_network_interface.infinite_nic
  ]


}

resource "azurerm_managed_disk" "infinite_disk" {
  for_each             = var.data_disks
  name                 = each.value.data_disk_name
  location             = var.location
  zone                 = var.zone
  resource_group_name  = var.resource_group_name
  storage_account_type = each.value.data_disk_storage_account_type
  create_option        = each.value.data_disk_create_option
  disk_size_gb         = each.value.data_disk_size_gb
  source_resource_id   = each.value.data_disk_create_option == "Empty" ? null : each.value.data_disk_source_uri
}

resource "azurerm_virtual_machine_data_disk_attachment" "infinite_disk_attachment" {
  for_each           = var.data_disks
  managed_disk_id    = azurerm_managed_disk.infinite_disk[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.infinite_windows_vm_standalone.id
  lun                = each.value.data_disk_lun_number
  caching            = each.value.data_disk_caching

  depends_on = [
    azurerm_managed_disk.infinite_disk,
    azurerm_windows_virtual_machine.infinite_windows_vm_standalone
  ]
}

module "domain-join" {
  source  = "kumarvna/domain-join/azurerm"
  version = "1.1.0"

  virtual_machine_id        = azurerm_windows_virtual_machine.infinite_windows_vm_standalone.id
  active_directory_domain   = var.active_directory_domain
  active_directory_username = var.active_directory_username
  active_directory_password = var.active_directory_password

  depends_on = [
    azurerm_windows_virtual_machine.infinite_windows_vm_standalone
  ]
}
