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
    { name = "subnet-sql-managed", address_prefixes = ["10.0.1.0/24"], delegation = "Microsoft.Sql/managedInstances" },
    { name = "subnet-sql", address_prefixes = ["10.0.2.0/24"], service_endpoints = ["Microsoft.Sql"] },
    { name = "subnet-web", address_prefixes = ["10.0.3.0/24"], service_endpoints = ["Microsoft.Storage", "Microsoft.Web"], delegation = "Microsoft.Web/serverFarms" }
  ]
}