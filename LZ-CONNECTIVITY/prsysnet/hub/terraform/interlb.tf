/*


resource "azurerm_public_ip" "intlb" {
  name                = "${var.name_prefix}-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group.name
  allocation_method   = "Static"
  sku                 = "standard"
}

resource "azurerm_lb" "lb" {
  name                = "${var.name_prefix}${var.sep}${var.name_lb}"
  location            = var.location
  resource_group_name = var.resource_group.name
  sku                 = "standard"

  dynamic "frontend_ip_configuration" {
    for_each = local.frontend_ips

    content {
      name                 = frontend_ip_configuration.value.name
      public_ip_address_id = frontend_ip_configuration.value.public_ip_address_id
    }
  }
}

locals {
  # The main input will go here through a sequence of operations to obtain the final result.

  # Recalculate the main input map, taking into account whether the boolean condition is true/false.
  frontend_ips = { for k, v in var.frontend_ips : k => {
    name                 = v.create_public_ip ? "${azurerm_public_ip.this[k].name}-fip" : k
    public_ip_address_id = v.create_public_ip ? azurerm_public_ip.this[k].id : v.public_ip_address_id
    rules                = v.rules
  } }

  # Terraform for_each unfortunately requires a single-dimensional map, but we have
  # a two-dimensional input. We need two steps for conversion.

  # Firstly, flatten() ensures that this local value is a flat list of objects, rather
  # than a list of lists of objects.
  input_flat_rules = flatten([
    for fipkey, fip in local.frontend_ips : [
      for rulekey, rule in fip.rules : {
        fipkey  = fipkey
        fip     = fip
        rulekey = rulekey
        rule    = rule
      }
    ]
  ])

  # Finally, convert flat list to a flat map. Make sure the keys are unique. This is used for for_each.
  input_rules = { for v in local.input_flat_rules : "${v.fipkey}-${v.rulekey}" => v }
}

resource "azurerm_lb_backend_address_pool" "lb-backend" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "${var.name_prefix}${var.sep}${var.name_backend}"
  resource_group_name = var.resource_group.name
}

resource "azurerm_lb_probe" "probe" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "${var.name_prefix}${var.sep}${var.name_probe}"
  port                = 80
  resource_group_name = var.resource_group.name
}

resource "azurerm_lb_rule" "lb-rules" {
  for_each = local.input_rules

  name                    = each.key
  resource_group_name = var.resource_group.name
  loadbalancer_id         = azurerm_lb.lb.id
  probe_id                = azurerm_lb_probe.probe.id
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb-backend.id

  protocol                       = each.value.rule.protocol
  backend_port                   = each.value.rule.port
  frontend_ip_configuration_name = each.value.fip.name
  frontend_port                  = each.value.rule.port
  enable_floating_ip             = true
}

*/