 resource "azurerm_key_vault" "keyvault" {
  name                        = local.settings.keyvault
  location                    = azurerm_resource_group.admin.location
  resource_group_name         = azurerm_resource_group.admin.name
  enabled_for_disk_encryption = local.settings.enabled_for_disk_encryption
  tenant_id                   = local.settings.tenant_id
  tags                        = local.settings.tags
  
  sku_name = local.settings.sku_name

  access_policy {
    tenant_id =  local.settings.tenant_id
    object_id =  local.settings.subscription_id
    
    key_permissions = [
      local.settings.key_permissions1,
      local.settings.key_permissions2
    ]

    secret_permissions = [
      local.settings.secret_permissions,
    ]

    storage_permissions = [
     local.settings.storage_permissions,
    ]
  }

  network_acls {
    default_action = local.settings.default_action
    bypass         = local.settings.bypass
  }

}