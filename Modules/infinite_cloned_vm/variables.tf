variable "nic_name" {
  description = "Name of the VM NIC"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Region where resources are located"
  type        = string
}

variable "zone" {
  description = "Region where VM is located"
  type        = string
}

variable "enable_accelerated_networking" {
  description = "Enable accelerated networking feature for the VM NIC"
  type        = bool
}

variable "availability_set_id" {
  description = "Availability set ID to which the VM is assigned"
  type        = string
}

variable "proximity_placement_group_id" {
  description = "Proximity placement group ID to which the VM is assigned"
  type        = string
}

variable "private_ip_address" {
  description = "Private IP allocated to VM"
  type        = string
}

variable "private_ip_address_allocation" {
  description = "Type of Private IP allocation to VM"
  type        = string
}

variable "network_security_group_id" {
  description = "List of NSGs to be associated with the VM"
  type        = string
}

variable "license_type" {
  description = "Enable Azure hybrid benefit for the VM"
  type        = string
}

variable "os_disk_snapshot_name" {
  description = "Name of snapshot created from original OS disk"
  type        = string
}

variable "source_os_disk_uri" {
  description = "Resource ID of Original VM OS disk"
  type        = string
}

variable "os_disk_name" {
  description = "Name of managed disk"
  type        = string
}

variable "os_disk_storage_account_type" {
  description = "Storage account type of managed disk"
  type        = string
}


variable "computer_name" {
  description = "Name of VM"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet to which VM is associated"
  type        = string
}

variable "size" {
  description = "Size of the VM to be created"
  type        = string
}

variable "os_type" {
  description = "Windows or Linux"
  type        = string
}

variable "os_disk_caching" {
  description = "Type of Caching which should be used for the Internal OS Disk"
  type        = string
}

variable "os_disk_size_gb" {
  description = "Size of the Internal OS Disk"
  type        = number
}

/* variable "data_disk_snapshots" {
  type = map(object({
    data_disk_snapshot_name = string
    data_disk_source_uri    = string
  }))
} */

variable "data_disks" {
  type = map(object({
    data_disk_name                 = string
    data_disk_storage_account_type = string
    data_disk_size_gb              = number
    data_disk_lun_number           = string
    data_disk_caching              = string
    data_disk_create_option        = string
    data_disk_source_uri =  string
  }))

}

variable "tags" {
  description = "Tags or labels for resources"
  type        = map(any)
}

variable "boot_diagnostics_storage_uri" {
  description = "Storage account for Boot diagnostics"
  type        = string
}

variable "timezone" {
  description = "Timezone to be set for VM"
  type        = string
}

variable "public_ip_name" {
  description = "Public IP Name allocated to VM"
  type        = string
}

variable "public_ip_address_allocation" {
  description = "Type of Public IP allocation to VM"
  type        = string
}






/* variable "network_security_group_id" {
  description = "ID of NSG to be associated with this VM"
  type        = string
} */


/*

variable "patch_mode" {
  description = "OS Patch mode for the VM to be created"
  type        = string
}

variable "gallery_image_name" {
  description = "gallery_image_name of VM"
  type        = string
}

variable "azure_compute_gallery_name" {
  description = "Azure compute gallery name"
  type        = string
}


 variable "data_disk_name" {
  description = "Name of data disk to be attached to VM"
  type        = string
}

variable "data_disk_storage_account_type" {
  description = "Storage type for the data disk"
  type        = string
}

variable "data_disk_create_option" {
  #description check
  description = "Create empty disk or attach existing disk"
  type        = string
}

variable "data_disk_size_gb" {
  description = "Data disk size in GB"
  type        = number
}

variable "data_disk_lun_number" {
  description = "LUN number to be assigned to data disk"
  type        = string
}

variable "data_disk_caching" {
  description = "Type of data disk caching"
  type        = string
} */

/*variable "vnet_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "address_space" {
  description = "Address space of the Virtual Network created"
  type        = any
}

variable "subnet_prefixes" {
  description = "Prefix of the Subnetwork created"
  type        = any
}

variable "subnet_names" {
  description = "Name of the Subnetwork created"
  type        = string
}
variable "admin_password" {
  description = "Password for Admin account"
  type        = string
}
*/

