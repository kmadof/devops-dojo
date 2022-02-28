provider "azurerm" {
   features {}
}

resource "azurerm_resource_group" "resource_group" {
  name     = "shilda-${var.env}-rg"
  location = "West Europe"
}

module "vnet" {
  source              = "aztfm/virtual-network/azurerm"
  version             = ">=2.0.0"
  name                = "shilda-${var.env}-vnet"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  address_space       = ["10.0.0.0/16"]
  subnets = [
    { name = "subnet1", address_prefixes = ["10.1.0.0/24"], delegation = "Microsoft.Sql/managedInstances" },
    { name = "subnet2", address_prefixes = ["10.2.0.0/24"], service_endpoints = ["Microsoft.Sql"] },
    { name = "subnet3", address_prefixes = ["10.3.0.0/24"], service_endpoints = ["Microsoft.Storage", "Microsoft.Web"], delegation = "Microsoft.Web/serverFarms" }
  ]
}