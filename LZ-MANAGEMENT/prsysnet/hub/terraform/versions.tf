
 terraform {

required_version = ">= 0.12"

required_providers {
    azurerm = {
      version = ">= 1.35.0"   
    }
  }
  backend "azurerm" {
    resource_group_name   = "rg-LurieTest"
    storage_account_name = "lurietestsa"
    container_name       = "lurietestcontainer"
    key                  = "hub.terraform.tfstate"
    access_key = "MWkhABVrksF3bQ4JRVMix2nWa4IdLjMOUl5kInurumhyUbXAuDoVNb04JaR/0GQxYKB+CmIwbNJmjc1J+KFusA=="
   }
 }

 provider "azurerm" {
 features{}

  subscription_id =  local.settings.subscription_id
 }

 
