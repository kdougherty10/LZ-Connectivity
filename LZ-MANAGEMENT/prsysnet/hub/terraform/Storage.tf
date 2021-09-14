resource "azurerm_storage_account" "storage" {
  name                     = local.settings.storagename
  resource_group_name      = azurerm_resource_group.admin.name
  location                 = azurerm_resource_group.admin.location
  account_tier             = local.settings.storage_account.account_tier
  access_tier              = local.settings.storage_account.access_tier
  account_replication_type = local.settings.storage_account.replication_type
  account_kind             = local.settings.storage_account.kind
  enable_https_traffic_only = local.settings.storage_account.enable_https_traffic_only
  tags                      = local.settings.tags
}


