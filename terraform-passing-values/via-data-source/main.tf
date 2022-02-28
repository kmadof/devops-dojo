terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.97.0"
    }
    azuredevops = {
      source = "microsoft/azuredevops"
      version = "0.2.0"
    }
  }
}

provider "azurerm" {
   features {}
}

resource "azurerm_resource_group" "resource_group" {
  name     = "shilda-${var.env}-rg"
  location = "West Europe"
}

data "azuredevops_project" "project" {
  name = "DevOps Dojo"
}

data "azuredevops_variable_group" "shilda" {
  project_id = data.azuredevops_project.project.id
  name       = "shilda-${var.env}"
}

/* locals {
  vnet_address_space = data.azuredevops_variable_group.shilda.variable
} */

resource "null_resource" "example2" {  
  provisioner "local-exec" {    
    command = "echo ${data.azuredevops_variable_group.shilda.variable["vnet_address_space"].name}"    
  }
}

/* module "vnet" {
  source              = "aztfm/virtual-network/azurerm"
  version             = ">=2.0.0"
  name                = "shilda-${var.env}-vnet"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  address_space       = [data.azuredevops_variable_group.shilda.vnet_address_space]
  subnets = [
    { name = "subnet-sql-managed", address_prefixes = [data.azuredevops_variable_group.shilda.subnet_sql_managed_address_prefixes], delegation = "Microsoft.Sql/managedInstances" },
    { name = "subnet-sql", address_prefixes = [data.azuredevops_variable_group.shilda.subnet_sql_address_prefixes], service_endpoints = ["Microsoft.Sql"] },
    { name = "subnet-web", address_prefixes = [data.azuredevops_variable_group.shilda.subnet_web_address_prefixes], service_endpoints = ["Microsoft.Storage", "Microsoft.Web"], delegation = "Microsoft.Web/serverFarms" }
  ]
} */