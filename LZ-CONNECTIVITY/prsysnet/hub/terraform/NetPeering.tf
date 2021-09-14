data "azurerm_subnet" "addssubnet" {
  name                 = "shs-prd-us-northcentral-ADD-SUBNET_10.205.0.0_26"
  virtual_network_name = "shs-prd-us-northcentral-vnet_10.205.0.0_22"
  resource_group_name  = "shs-prd-northcentralus-connectivity-rg"
}

data "azurerm_subnet" "spoke" {
  name                 = "AzureBastionSubnet"
  virtual_network_name = "DAR-PRD-NCUS-VNET"
  resource_group_name  = "shs-prd-northcentralus-monitoring-rg"
}

data "azurerm_virtual_network" "spokevnet" {
  name                = "DAR-PRD-NCUS-VNET"
  resource_group_name = "shs-prd-northcentralus-monitoring-rg"
}

data "azurerm_virtual_network" "hubvnet" {
  name                = "shs-prd-us-northcentral-vnet_10.205.0.0_22"
  resource_group_name = "shs-prd-northcentralus-connectivity-rg"
}

##Connect to
resource "azurerm_virtual_network_peering" "spoke-1" {
name = local.settings.vnet-1-hub-peername
resource_group_name = data.azurerm_subnet.spoke.resource_group_name
virtual_network_name = data.azurerm_subnet.spoke.virtual_network_name
remote_virtual_network_id = data.azurerm_virtual_network.hubvnet.id
allow_virtual_network_access = local.settings.network_access
allow_forwarded_traffic = local.settings.forwarded_traffic
allow_gateway_transit = local.settings.gateway_transit
use_remote_gateways = local.settings.allow_remote_gateway
}
##Connect From
resource "azurerm_virtual_network_peering" "hub-spoke-1" {
name = local.settings.hub-vnet-1-peername
#provider = azurerm.hub
resource_group_name = data.azurerm_virtual_network.hubvnet.resource_group_name
virtual_network_name = data.azurerm_virtual_network.hubvnet.name
remote_virtual_network_id = data.azurerm_virtual_network.spokevnet.id
allow_virtual_network_access = local.settings.network_access
allow_forwarded_traffic = local.settings.forwarded_traffic
allow_gateway_transit = local.settings.gateway_transit
}