resource "azurerm_resource_group" "this" {
  name     = "rg-bastion-full"
  location = "germanywestcentral"
}

module "vnet_full" {
  source = "CloudAstro/virtual-network/azurerm"

  name                = "vnet-full"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.30.0.0/16"]
}

module "subnet_bastion" {
  source = "CloudAstro/subnet/azurerm"

  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = module.vnet_full.virtual_network.name
  address_prefixes     = ["10.30.0.0/26"]
}

module "pip_bastion" {
  source = "CloudAstro/public-ip/azurerm"

  name                = "pip-bastion-example"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Standard"
  allocation_method   = "Static"
  zones               = ["1"]
}

module "bastion_host" {
  source = "../../"

  name                      = "bastion-full"
  location                  = azurerm_resource_group.this.location
  resource_group_name       = azurerm_resource_group.this.name
  copy_paste_enabled        = true
  file_copy_enabled         = true
  ip_connect_enabled        = true
  kerberos_enabled          = true
  scale_units               = 3
  shareable_link_enabled    = true
  tunneling_enabled         = true
  session_recording_enabled = false
  sku                       = "Standard"
  zones                     = ["1"]

  ip_configuration = {
    name                 = "ipconfig1"
    subnet_id            = module.subnet_bastion.subnet.id
    public_ip_address_id = module.pip_bastion.publicip.id
  }

  tags = {
    environment = "lab"
    owner       = "ricloud"
  }
}
