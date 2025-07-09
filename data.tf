locals {
  subnet_id_parts = split("/", var.ip_configuration.subnet_id)
  rg_index        = length(local.subnet_id_parts) - 7
  vnet_index      = length(local.subnet_id_parts) - 3
  sn_index        = length(local.subnet_id_parts) - 1
}

data "azurerm_subnet" "bastion" {
  name                 = local.subnet_id_parts[local.sn_index]
  virtual_network_name = local.subnet_id_parts[local.vnet_index]
  resource_group_name  = local.subnet_id_parts[local.rg_index]
}
