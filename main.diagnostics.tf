# Create diagnostic setting for Azure Bastion
resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = var.diagnostic_setting != null ? var.diagnostic_setting : {}

  name                           = each.value.name
  target_resource_id             = azurerm_bastion_host.this.id
  eventhub_authorization_rule_id = each.value.eventhub_authorization_rule_id
  eventhub_name                  = each.value.eventhub_name
  log_analytics_workspace_id     = each.value.log_analytics_workspace_id
  storage_account_id             = each.value.storage_account_id
  log_analytics_destination_type = each.value.log_analytics_destination_type
  partner_solution_id            = each.value.partner_solution_id

  dynamic "enabled_log" {
    for_each = each.value.enabled_log != null ? each.value.enabled_log : []

    content {
      category       = enabled_log.value.category_group == null ? enabled_log.value.category : null
      category_group = enabled_log.value.category_group
    }
  }

  dynamic "metric" {
    for_each = each.value.metric != null ? [each.value.metric] : []

    content {
      category = metric.value.category
      enabled  = metric.value.enabled
    }
  }
  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []

    content {
      create = timeouts.value.create
      update = timeouts.value.update
      read   = timeouts.value.read
      delete = timeouts.value.delete
    }
  }
}
