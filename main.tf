
resource "azurerm_proximity_placement_group" "infinite-ppg" {
  depends_on = [
    #azurerm_resource_group.infinite-rg
  ]

  for_each            = var.proximity_placement_groups
  name                = each.value.proximity_placement_group_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location

}

resource "azurerm_availability_set" "infinite-availability-set" {
  depends_on = [
    #azurerm_resource_group.infinite-rg
  ]
  for_each                     = var.availability_sets
  name                         = each.value.availability_set_name
  location                     = each.value.location
  resource_group_name          = each.value.resource_group_name
  proximity_placement_group_id = (each.value.proximity_placement_group_name == null) ? null : azurerm_proximity_placement_group.infinite-ppg[each.value.proximity_placement_group_name].id
  platform_fault_domain_count = each.value.platform_fault_domain_count
  platform_update_domain_count = each.value.platform_update_domain_count
}

module "infinite_linux_vm" {
  source = "./Modules/infinite_linux_vm/"
  depends_on = [
    #azurerm_resource_group.infinite-rg,
    azurerm_availability_set.infinite-availability-set,
    azurerm_proximity_placement_group.infinite-ppg,
  ]

  for_each = var.infinite_linux_vms

  location                      = each.value.location
  zone                          = each.value.zone
  nic_name                      = each.value.nic_name
  enable_accelerated_networking = each.value.enable_accelerated_networking
  #subnet_id                     = module.vnet[each.value.vnet_name].subnet_ids[each.value.subnet_names]
  subnet_id                    = each.value.subnet_id
  proximity_placement_group_id = (each.value.proximity_placement_group_name != null) ? azurerm_proximity_placement_group.infinite-ppg[each.value.proximity_placement_group_name].id : each.value.proximity_placement_group_id

  availability_set_id = (each.value.availability_set_name != null) ? azurerm_availability_set.infinite-availability-set[each.value.availability_set_name].id : each.value.availability_set_id

  #availability_set_id = (each.value.availability_set_name != null) ? azurerm_availability_set.infinite-availability-set[each.value.availability_set_name].id : each.value.availability_set_id

  network_security_group_id = each.value.network_security_group_id


  resource_group_name           = each.value.resource_group_name
  private_ip_address_allocation = each.value.private_ip_address_allocation
  private_ip_address            = each.value.private_ip_address
  additional_private_ip_addresses = each.value.additional_private_ip_addresses


  computer_name = each.value.computer_name
  size          = each.value.size

  patch_mode                      = each.value.patch_mode
  admin_username                  = each.value.admin_username
  admin_password                  = each.value.admin_password
  admin_ssh_key_username          = each.value.admin_ssh_key_username
  disable_password_authentication = each.value.disable_password_authentication
  public_key                      = each.value.public_key
  license_type = each.value.license_type
  #public_key                      = format("%s/%s", "${path.module}", each.value.public_key)

  os_disk_storage_account_type = each.value.os_disk_storage_account_type
  os_disk_name                 = each.value.os_disk_name
  os_disk_caching              = each.value.os_disk_caching
  os_disk_size_gb              = each.value.os_disk_size_gb

  source_image_reference_publisher = each.value.source_image_reference_publisher
  source_image_reference_offer     = each.value.source_image_reference_offer
  source_image_reference_sku       = each.value.source_image_reference_sku
  source_image_reference_version   = each.value.source_image_reference_version


  source_image_id = each.value.source_image_id



  data_disks = each.value.data_disks

  tags      = each.value.tags
  user_data = each.value.user_data
  timezone  = each.value.timezone

  public_ip_address_allocation = each.value.public_ip_address_allocation
  public_ip_name               = each.value.public_ip_name
  boot_diagnostics_storage_uri = each.value.boot_diagnostics_storage_uri
  #active_directory_domain   = each.value.active_directory_domain
  #active_directory_username = each.value.active_directory_username
  #active_directory_password = each.value.active_directory_password  
}


module "infinite_windows_vm_standalone" {
  source = "./Modules/infinite_windows_vm_standalone"
  depends_on = [
    azurerm_availability_set.infinite-availability-set,
    azurerm_proximity_placement_group.infinite-ppg
  ]

  for_each = var.infinite_windows_vm_standalone

  location                      = each.value.location
  zone                          = each.value.zone
  nic_name                      = each.value.nic_name
  enable_accelerated_networking = each.value.enable_accelerated_networking
  subnet_id                     = each.value.subnet_id
  proximity_placement_group_id = (each.value.proximity_placement_group_name != null) ? azurerm_proximity_placement_group.infinite-ppg[each.value.proximity_placement_group_name].id : each.value.proximity_placement_group_id

  availability_set_id       = (each.value.availability_set_name != null) ? azurerm_availability_set.infinite-availability-set[each.value.availability_set_name].id : each.value.availability_set_id
  network_security_group_id = each.value.network_security_group_id

  resource_group_name             = each.value.resource_group_name
  private_ip_address_allocation   = each.value.private_ip_address_allocation
  private_ip_address              = each.value.private_ip_address
  additional_private_ip_addresses = each.value.additional_private_ip_addresses
  computer_name                   = each.value.computer_name
  size                            = each.value.size

  patch_mode               = each.value.patch_mode
  enable_automatic_updates   = each.value.enable_automatic_updates
  admin_username           = each.value.admin_username
  admin_password           = each.value.admin_password
  license_type = each.value.license_type

  os_disk_storage_account_type = each.value.os_disk_storage_account_type
  os_disk_name                 = each.value.os_disk_name
  os_disk_caching              = each.value.os_disk_caching
  os_disk_size_gb              = each.value.os_disk_size_gb

  source_image_reference_publisher = each.value.source_image_reference_publisher
  source_image_reference_offer     = each.value.source_image_reference_offer
  source_image_reference_sku       = each.value.source_image_reference_sku
  source_image_reference_version   = each.value.source_image_reference_version

  source_image_id = each.value.source_image_id

  data_disks = each.value.data_disks

  tags                         = each.value.tags
  user_data                    = each.value.user_data
  timezone                     = each.value.timezone
  public_ip_address_allocation = each.value.public_ip_address_allocation
  public_ip_name               = each.value.public_ip_name
  boot_diagnostics_storage_uri = each.value.boot_diagnostics_storage_uri
  active_directory_domain   = each.value.active_directory_domain
  active_directory_username = each.value.active_directory_username
  active_directory_password = each.value.active_directory_password
  #ivanti_api_endpoint       = each.value.ivanti_api_endpoint
  #ivanti_username            = each.value.ivanti_username
  #ivanti_password            = each.value.ivanti_password
  #server_name               = each.value.server_name
}

/*
module "domain-join" {
  source  = "kumarvna/domain-join/azurerm"
  version = "1.1.0"

  for_each = var.infinite_windows_vm_standalone

  virtual_machine_id        = module.infinite_windows_vm_standalone[each.key].id
  active_directory_domain   = each.value.active_directory_domain
  active_directory_username = each.value.active_directory_username
  active_directory_password = each.value.active_directory_password

  depends_on = [
    azurerm_windows_virtual_machine.infinite_windows_vm_standalone
  ]  
}
*/
