locals {
  settings = yamldecode(file("../../environments/hub/${terraform.workspace}/terraform.yaml"))
  #settings = yamldecode(file("../environments/hub/${terraform.workspace}/terraform.yaml"))
  #settings = yamldecode(file("../../environments/hub/hubeastus2/terraform.yaml"))
}
/*


resource "azurerm_resource_group" "hub" {
  name = data.azurerm_resource_group.connectivity
  location = local.settings.location
  tags = local.settings.tags
}

resource "azurerm_resource_group" "hub" {
  name     = "${local.settings.type}-${local.settings.org}-${local.settings.locationtype}-${local.settings.nettype}-${local.settings.rg}"
  location = local.settings.location
  tags     = local.settings.tags

}

resource "azurerm_resource_group" "admin" {
   name     = "${local.settings.type}-${local.settings.org}-${local.settings.locationtype}-${local.settings.cloudtype}-${local.settings.rg}"
   location = local.settings.location
   tags     = local.settings.tags
}

resource "azurerm_resource_group" "ADDS" {
   name     = "${local.settings.type}-${local.settings.org}-${local.settings.locationtype}-${local.settings.addstype}-${local.settings.rg}"
   location = local.settings.location
   tags     = local.settings.tags
}



resource "azurerm_resource_group" "pan" {
  name     = "${local.settings.type}-${local.settings.org}-${local.settings.locationtype}-${local.settings.fwtype}-${local.settings.rg}"
  location = local.settings.location
  tags     = local.settings.tags

}

resource "azurerm_resource_group" transit {
  name     = "${local.settings.type}-${local.settings.org}-${local.settings.locationtype}-${local.settings.trantype}-${local.settings.rg}"
  location = local.settings.location
  tags     = local.settings.tags

}
*/