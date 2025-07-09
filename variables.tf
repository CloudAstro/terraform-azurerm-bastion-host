variable "name" {
  type        = string
  description = <<DESCRIPTION
  * `name` - (Required) Specifies the name of the Bastion Host. Changing this forces a new resource to be created.

  Example Input:
  ```
  name = "myBastionHost"
  ```
  DESCRIPTION
}

variable "resource_group_name" {
  type        = string
  description = <<DESCRIPTION
 * `resource_group_name` - (Required) The name of the resource group in which to create the Bastion Host. Changing this forces a new resource to be created.

  Example Input:
  ```
  resource_group_name = "myResourceGroup"
  ```
  DESCRIPTION
}

variable "location" {
  type        = string
  description = <<DESCRIPTION
  * `location` - (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. Review [Azure Bastion Host FAQ](https://docs.microsoft.com/azure/bastion/bastion-faq) for supported locations.

  Example Input:
  ```
  location = "germanywestcentral"
  ```
  DESCRIPTION
}

variable "copy_paste_enabled" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
  * `copy_paste_enabled` - (Optional) Is Copy/Paste feature enabled for the Bastion Host. Defaults to `true`.

  Example Input:
  ```
  copy_paste_enabled = "true"
  ```
  DESCRIPTION
}

variable "file_copy_enabled" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
  * `copy_paste_enabled` - (Optional) Is Copy/Paste feature enabled for the Bastion Host. Defaults to `true`.

  ~> **Note:** `file_copy_enabled` is only supported when `sku` is `Standard` or `Premium`.

  Example Input:
  ```
  file_copy_enabled = "false"
  ```
  DESCRIPTION

  validation {
    condition     = !var.file_copy_enabled || contains(["Standard", "Premium"], var.sku)
    error_message = "file_copy_enabled can only be true when sku is \"Standard\" or \"Premium\"."
  }
}

variable "sku" {
  type        = string
  default     = "Basic"
  description = <<DESCRIPTION
  * `sku` - (Optional) The SKU of the Bastion Host. Accepted values are `Developer`, `Basic`, `Standard` and `Premium`. Defaults to `Basic`.

  ~> **Note** Downgrading the SKU will force a new resource to be created.

  Example Input:
  ```
  sku = "Standard"
  ```
  DESCRIPTION
}



variable "ip_connect_enabled" {
  type        = bool
  default     = false
  description = <<DESCRIPTION
  * `ip_connect_enabled` - (Optional) Is IP Connect feature enabled for the Bastion Host. Defaults to `false`.

  ~> **Note:** `ip_connect_enabled` is only supported when `sku` is `Standard` or `Premium`.

  Example Input:
  ```
  ip_connect_enabled = "false"
  ```
  DESCRIPTION
}

variable "kerberos_enabled" {
  type        = bool
  default     = false
  description = <<DESCRIPTION
  * `kerberos_enabled` - (Optional) Is Kerberos authentication feature enabled for the Bastion Host. Defaults to `false`.

  ~> **Note:** `kerberos_enabled` is only supported when `sku` is `Standard` or `Premium`.

  Example Input:
  ```
  kerberos_enabled = "false"
  ```
  DESCRIPTION
}

variable "scale_units" {
  type    = number
  default = 2
  validation {
    condition     = var.scale_units >= 2 && var.scale_units <= 50
    error_message = "scale_units must be between 2 and 50."
  }
  description = <<DESCRIPTION
  * `scale_units` - (Optional) The number of scale units with which to provision the Bastion Host. Possible values are between `2` and `50`. Defaults to `2`.

  ~> **Note:** `scale_units` only can be changed when `sku` is `Standard` or `Premium`. `scale_units` is always `2` when `sku` is `Basic`.

  Example Input:
  ```
  scale_units = "2"
  ```
  DESCRIPTION

  validation {
    condition     = var.scale_units == null || contains(["Standard", "Premium"], var.sku)
    error_message = "scale_units is only valid when sku is \"Standard\" or \"Premium\"."
  }
}

variable "shareable_link_enabled" {
  type        = bool
  default     = false
  description = <<DESCRIPTION
  * `shareable_link_enabled` - (Optional) Is Shareable Link feature enabled for the Bastion Host. Defaults to `false`.

  ~> **Note:** `shareable_link_enabled` is only supported when `sku` is `Standard` or `Premium`. Example Input:

  Example Input:
  ```
  shareable_link_enabled = "false"
  ```
  DESCRIPTION
}

variable "tunneling_enabled" {
  type        = bool
  default     = false
  description = <<DESCRIPTION
  * `tunneling_enabled` - (Optional) Is Tunneling feature enabled for the Bastion Host. Defaults to `false`.

  ~> **Note:** `tunneling_enabled` is only supported when `sku` is `Standard` or `Premium`.```

  Example Input:
  ```
  tunneling_enabled = "false"
  ```
  DESCRIPTION

  validation {
    condition     = !var.tunneling_enabled || contains(["Standard", "Premium"], var.sku)
    error_message = "tunneling_enabled can only be true when sku is \"Standard\" or \"Premium\"."
  }
}

variable "session_recording_enabled" {
  type        = bool
  default     = false
  description = <<DESCRIPTION
  * `session_recording_enabled` - (Optional) Is Session Recording feature enabled for the Bastion Host. Defaults to `false`.

  ~> **Note:** `session_recording_enabled` is only supported when `sku` is `Premium`.

  Example Input:
  ```
  session_recording_enabled = "false"
  ```
  DESCRIPTION

  validation {
    condition     = !var.session_recording_enabled || var.sku == "Premium"
    error_message = "session_recording_enabled can only be true when sku is \"Premium\"."
  }
}

variable "virtual_network_id" {
  type        = string
  default     = null
  description = <<DESCRIPTION
  * `virtual_network_id` - (Optional) The ID of the Virtual Network for the Developer Bastion Host. Changing this forces a new resource to be created.

  ~> **Note:** `session_recording_enabled` is only supported when `sku` is `Premium`.

  Example Input:
  ```
  virtual_network_id = "/subscriptions/xxxx/resourceGroups/xxxx/providers/Microsoft.Network/virtualNetworks/myVnet"
  ```
  DESCRIPTION
}

variable "zones" {
  type        = list(string)
  default     = null
  description = <<DESCRIPTION
  * `zones` - (Optional) Specifies a list of Availability Zones in which this Public Bastion Host should be located. Changing this forces a new resource to be created.

  Example Input:
  ```
  zones = ["1", "2"]
  ```
  DESCRIPTION
}

variable "ip_configuration" {
  type = object({
    name                 = string
    subnet_id            = string
    public_ip_address_id = string
  })
  default     = null
  description = <<DESCRIPTION
  * `ip_configuration` - (Optional) A `ip_configuration` block as defined below. Changing this forces a new resource to be created.
  A `ip_configuration` block supports the following:
    * `name` - (Required) The name of the IP configuration. Changing this forces a new resource to be created.
    * `subnet_id` - (Required) Reference to a subnet in which this Bastion Host has been created. Changing this forces a new resource to be created.
    ~> **Note:** The Subnet used for the Bastion Host must have the name `AzureBastionSubnet` and the subnet mask must be at least a `/26`.
    * `public_ip_address_id` - (Required) Reference to a Public IP Address to associate with this Bastion Host. Changing this forces a new resource to be created.

  Example Input:
  ```
  ip_configuration = {
    name = "myIpConfig"
    subnet_id = "/subscriptions/xxxx/resourceGroups/xxxx/providers/Microsoft.Network/virtualNetworks/myVnet/subnets/AzureBastionSubnet"
    public_ip_address_id = "/subscriptions/xxxx/resourceGroups/xxxx/providers/Microsoft.Network/publicIPAddresses/myPublicIP"
  }
  ```
  DESCRIPTION
}

variable "tags" {
  type        = map(string)
  default     = null
  description = <<DESCRIPTION
  * `tags` - (Optional) A mapping of tags to assign to the resource.

  Example input:
  ```
  tags = {
    env     = test
    region  = gwc
  }
  ```
  DESCRIPTION
}

variable "timeouts" {
  type = object({
    create = optional(string, "30")
    read   = optional(string, "5")
    update = optional(string, "30")
    delete = optional(string, "30")
  })
  default     = null
  description = <<DESCRIPTION
  The `timeouts` block allows you to specify [timeouts](https://www.terraform.io/language/resources/syntax#operation-timeouts) for certain actions:
    * `create` - (Defaults to 30 minutes) Used when creating the Bastion Host.
    * `read` - (Defaults to 5 minutes) Used when retrieving the Bastion Host.
    * `update` - (Defaults to 30 minutes) Used when updating the Bastion Host.
    * `delete` - (Defaults to 30 minutes) Used when deleting the Bastion Host.
DESCRIPTION
}
