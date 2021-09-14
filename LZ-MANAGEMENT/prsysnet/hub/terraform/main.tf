locals {
  settings = yamldecode(file("../../environments/hub/${terraform.workspace}/terraform.yaml"))
  
}


resource "azurerm_resource_group" "admin" {
   name     = "${local.settings.type}-${local.settings.org}-${local.settings.locationtype}-${local.settings.cloudtype}-${local.settings.rg}"
   location = local.settings.location
   tags     = local.settings.tags2
}
