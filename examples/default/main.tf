resource "azurerm_resource_group" "this" {
  name     = "rg-bastion-example"
  location = "germanywestcentral"
}

module "vnet_example" {
  source = "CloudAstro/virtual-network/azurerm"

  name                = "vnet-example"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.20.0.0/16"]
}

module "subnet_bastion" {
  source = "CloudAstro/subnet/azurerm"

  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = module.vnet_example.virtual_network.name
  address_prefixes     = ["10.20.0.0/26"]
}

module "pip_bastion" {
  source = "CloudAstro/public-ip/azurerm"

  name                = "pip-bastion-example"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Standard"
  allocation_method   = "Static"
}

module "bastion_host" {
  source = "../../"

  name                = "bastion-example"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Standard"

  ip_configuration = {
    name                 = "ipconfig1"
    subnet_id            = module.subnet_bastion.subnet.id
    public_ip_address_id = module.pip_bastion.publicip.id
  }
}
