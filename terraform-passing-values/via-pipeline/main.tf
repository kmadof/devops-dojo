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
  address_space       = [var.subnet_sql_address_prefixes]
  subnets = [
    { name = "subnet-sql-managed", address_prefixes = [var.subnet_sql_managed_address_prefixes], delegation = "Microsoft.Sql/managedInstances" },
    { name = "subnet-sql", address_prefixes = [var.subnet_web_address_prefixes], service_endpoints = ["Microsoft.Sql"] },
    { name = "subnet-web", address_prefixes = [var.vnet_address_space], service_endpoints = ["Microsoft.Storage", "Microsoft.Web"], delegation = "Microsoft.Web/serverFarms" }
  ]
}