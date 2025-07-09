resource "azurerm_bastion_host" "this" {
  name                      = var.name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  copy_paste_enabled        = var.copy_paste_enabled
  file_copy_enabled         = contains(["Standard", "Premium"], var.sku) ? var.file_copy_enabled : null
  sku                       = var.sku
  ip_connect_enabled        = var.ip_connect_enabled
  kerberos_enabled          = var.kerberos_enabled
  scale_units               = contains(["Standard", "Premium"], var.sku) ? var.scale_units : null
  shareable_link_enabled    = var.shareable_link_enabled
  tunneling_enabled         = contains(["Standard", "Premium"], var.sku) ? var.tunneling_enabled : null
  session_recording_enabled = var.sku == "Premium" ? var.session_recording_enabled : null
  virtual_network_id        = var.virtual_network_id
  zones                     = var.zones
  tags                      = var.tags

  dynamic "ip_configuration" {
    for_each = var.ip_configuration != null ? [var.ip_configuration] : []

    content {
      name                 = ip_configuration.value.name
      subnet_id            = ip_configuration.value.subnet_id
      public_ip_address_id = ip_configuration.value.public_ip_address_id
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      read   = timeouts.value.read
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }

  lifecycle {
    precondition {
      condition = (
        var.sku == "Developer" || (
          length(data.azurerm_subnet.bastion.address_prefixes) == 1 &&
          tonumber(split("/", data.azurerm_subnet.bastion.address_prefixes[0])[1]) <= 26
        )
      )
      error_message = "AzureBastionSubnet must be /26 or larger (/26, /25, /24 …)."
    }
  }
}
