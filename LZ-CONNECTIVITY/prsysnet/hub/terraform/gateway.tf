## This file left out of build intentionally, if rebuilding the VDC from scratch rename this file with a .tf extension
## Azure S2S IPSEC tunnel configuration
## if rebuilt, adjust IKE gateway on client

## Azure ExpressRoute Gateway configuration

##Data Source for Gateway Subnet ##

data "azurerm_resource_group" "hub" {
  name = "shs-prd-northcentralus-connectivity-rg"
}

data "azurerm_subnet" "gatewaysubnet" {
  name                 = "GatewaySubnet"
  virtual_network_name = "shs-prd-us-northcentral-vnet_10.205.0.0_22"
  resource_group_name  = "shs-prd-northcentralus-connectivity-rg"
}

resource "azurerm_public_ip" "pip-LCH-vng" {
  name                = local.settings.vng_pip
  location            = data.azurerm_resource_group.hub.location
  resource_group_name = data.azurerm_resource_group.hub.name
  sku                 = local.settings.pip-sku
  allocation_method   = local.settings.pip-alloc-method

  tags = local.settings.tags
}

resource "azurerm_local_network_gateway" "LCHlgw" {
  name                = local.settings.localgw
  resource_group_name = data.azurerm_resource_group.hub.name
  location            = data.azurerm_resource_group.hub.location
  gateway_address     = local.settings.gateway_address  #Peered IP onprem 
  address_space       = local.settings.localnetgateway1 # LAN Subnets
  tags                = local.settings.tags
  bgp_settings {
    asn                 = local.settings.netgwasn
    bgp_peering_address = local.settings.netgw_bgp_peer
  }
}
/*
resource "azurerm_virtual_network_gateway" "LCH_vng" {
  name                = "${local.settings.vng_name}"
  location            =  data.azurerm_resource_group.hub.location
  resource_group_name =  data.azurerm_resource_group.hub.name
  type                =  local.settings.gateway-type
  vpn_type            =  local.settings.vpn-type
  enable_bgp          =  local.settings.enable-bgp
  sku                 =  local.settings.gateway-sku
  ## Azure IKE gateway
  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = "${azurerm_public_ip.pip-LCH-vng.id}"
    private_ip_address_allocation =  local.settings.vngw-private-ip-alloc
    subnet_id                     = data.azurerm_subnet.gatewaysubnet.id
  }
  
  tags = local.settings.tags
}
*/

## New Config

resource "azurerm_virtual_network_gateway" "LCH_vng" {
name = local.settings.vng_name
location = data.azurerm_resource_group.hub.location
resource_group_name = data.azurerm_resource_group.hub.name
type = local.settings.gateway-type1
vpn_type = local.settings.vpn-type
enable_bgp = local.settings.enable-bgp
sku = local.settings.vpn-sku
active_active = local.settings.active_active
generation = local.settings.vpngeneration
tags = local.settings.tags
bgp_settings {
asn = local.settings.vpnasn
}
## Azure IKE gateway

ip_configuration {
name = local.settings.vnetipconfig
public_ip_address_id = azurerm_public_ip.pip-LCH-vng.id
private_ip_address_allocation = local.settings.vngw-private-ip-alloc
subnet_id = data.azurerm_subnet.gatewaysubnet.id
}
}

resource "azurerm_virtual_network_gateway_connection" "LCHnetgw" {
  name                       = local.settings.netgw
  resource_group_name        = data.azurerm_resource_group.hub.name
  location                   = data.azurerm_resource_group.hub.location
  type                       = local.settings.netgateconntype
  virtual_network_gateway_id = azurerm_virtual_network_gateway.LCH_vng.id
  local_network_gateway_id   = azurerm_local_network_gateway.LCHlgw.id
  shared_key                 = local.settings.presharedkey
  enable_bgp                 = true
  ipsec_policy {
    dh_group = "DHGroup14"
    ike_encryption = "AES256"
    ike_integrity = "SHA256"
    ipsec_encryption = "AES256"
    ipsec_integrity = "SHA256"
    pfs_group = "PFS24"
    sa_lifetime = 27000
    sa_datasize = 102400000
  }
  tags                       = local.settings.tags

}


