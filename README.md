<!-- BEGINNING OF PRE-COMMIT-OPENTOFU DOCS HOOK -->
<!-- BEGIN\_TF\_DOCS -->
# azurerm\_bastion\_host Module

This module is designed to manage an Azure Bastion. The module supports configuration of diagnostic settings, role assignments, and various other features to manage and secure your Azure Bastion.

# Features

- **Secure RDP and SSH Access**: Establish RDP and SSH sessions directly in the Azure portal over Transport Layer Security (TLS), ensuring encrypted connections without exposing VMs to the public internet.
- **No Public IP Requirement**: Access VMs using their private IP addresses, eliminating the necessity for public IPs and reducing the attack surface.
- **Agentless Connection:**: Connect to VMs without installing additional agents or software; Azure Bastion is an agentless service.
- **Support for Multiple SKUs**: Azure Bastion offers various SKUs—Developer, Basic, Standard, and Premium—each providing different features and scalability options to meet diverse organizational needs.
- **Advanced Features in Higher SKUs** Standard and Premium SKUs offer additional capabilities such as:
  - **File Transfer**: Upload and download files between your local machine and the VM during an RDP or SSH session.
  - **Session Recording**:  Record user sessions for auditing and compliance purposes.
  - **Kerberos Authentication**: Utilize Kerberos for authentication to enhance security.
  - **Shareable Links**: Generate links to provide temporary access to VMs without exposing them to the public internet.
  - **Tunneling**: Establish secure tunnels to VMs, enabling access to applications running on the VM without exposing ports.
- **Diagnostic Settings**: Enables monitoring and logging for Azure Bastion resources to maintain performance and

# Example Usage

```hcl
resource "azurerm_resource_group" "this" {
  name     = "rg-bastion-full"
  location = "germanywestcentral"
}

module "vnet_full" {
  source = "CloudAstro/virtual-network/azurerm"

  name                = "vnet-full"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.30.0.0/16"]
}

module "subnet_bastion" {
  source = "CloudAstro/subnet/azurerm"

  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = module.vnet_full.virtual_network.name
  address_prefixes     = ["10.30.0.0/26"]
}

module "pip_bastion" {
  source = "CloudAstro/public-ip/azurerm"

  name                = "pip-bastion-example"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Standard"
  allocation_method   = "Static"
  zones               = ["1"]
}

module "bastion_host" {
  source = "../../"

  name                      = "bastion-full"
  location                  = azurerm_resource_group.this.location
  resource_group_name       = azurerm_resource_group.this.name
  copy_paste_enabled        = true
  file_copy_enabled         = true
  ip_connect_enabled        = true
  kerberos_enabled          = true
  scale_units               = 3
  shareable_link_enabled    = true
  tunneling_enabled         = true
  session_recording_enabled = false
  sku                       = "Standard"
  zones                     = ["1"]

  ip_configuration = {
    name                 = "ipconfig1"
    subnet_id            = module.subnet_bastion.subnet.id
    public_ip_address_id = module.pip_bastion.publicip.id
  }

  tags = {
    environment = "lab"
    owner       = "ricloud"
  }
}
```
<!-- markdownlint-disable MD033 -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_bastion_host.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host) | resource |
| [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_subnet.bastion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

<!-- markdownlint-disable MD013 -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | * `location` - (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. Review [Azure Bastion Host FAQ](https://docs.microsoft.com/azure/bastion/bastion-faq) for supported locations.<br/><br/>  Example Input:<pre>location = "germanywestcentral"</pre> | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | * `name` - (Required) Specifies the name of the Bastion Host. Changing this forces a new resource to be created.<br/><br/>  Example Input:<pre>name = "myBastionHost"</pre> | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | * `resource_group_name` - (Required) The name of the resource group in which to create the Bastion Host. Changing this forces a new resource to be created.<br/><br/>  Example Input:<pre>resource_group_name = "myResourceGroup"</pre> | `string` | n/a | yes |
| <a name="input_copy_paste_enabled"></a> [copy\_paste\_enabled](#input\_copy\_paste\_enabled) | * `copy_paste_enabled` - (Optional) Is Copy/Paste feature enabled for the Bastion Host. Defaults to `true`.<br/><br/>  Example Input:<pre>copy_paste_enabled = "true"</pre> | `bool` | `true` | no |
| <a name="input_diagnostic_setting"></a> [diagnostic\_setting](#input\_diagnostic\_setting) | The following arguments are supported:<br/>  * `name` - (Required) Specifies the name of the Diagnostic Setting. Changing this forces a new resource to be created.<br/>  -> **NOTE:** If the name is set to 'service' it will not be possible to fully delete the diagnostic setting. This is due to legacy API support.<br/>  * `eventhub_name` - (Optional) Specifies the name of the Event Hub where Diagnostics Data should be sent.<br/>  -> **NOTE:** If this isn't specified then the default Event Hub will be used.<br/>  * `eventhub_authorization_rule_id` - (Optional) Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data.<br/>  -> **NOTE:** This can be sourced from [the `azurerm_eventhub_namespace_authorization_rule` resource](eventhub\_namespace\_authorization\_rule.html) and is different from [a `azurerm_eventhub_authorization_rule` resource](eventhub\_authorization\_rule.html).<br/>  -> **NOTE:** At least one of `eventhub_authorization_rule_id`, `log_analytics_workspace_id`, `partner_solution_id` and `storage_account_id` must be specified.<br/>  * `enabled_log` - (Optional) One or more `enabled_log` blocks as defined below.<br/>  -> **NOTE:** At least one `enabled_log` or `metric` block must be specified. At least one type of Log or Metric must be enabled.<br/>  * `log_analytics_workspace_id` - (Optional) Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent.<br/>  -> **NOTE:** At least one of `eventhub_authorization_rule_id`, `log_analytics_workspace_id`, `partner_solution_id` and `storage_account_id` must be specified.<br/>  * `metric` - (Optional) One or more `metric` blocks as defined below.<br/>  -> **NOTE:** At least one `enabled_log` or `metric` block must be specified.<br/>  * `storage_account_id` - (Optional) The ID of the Storage Account where logs should be sent.<br/>  -> **NOTE:** At least one of `eventhub_authorization_rule_id`, `log_analytics_workspace_id`, `partner_solution_id` and `storage_account_id` must be specified.<br/>  * `log_analytics_destination_type` - (Optional) Possible values are `AzureDiagnostics` and `Dedicated`. When set to `Dedicated`, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy `AzureDiagnostics` table.<br/>  -> **NOTE:** This setting will only have an effect if a `log_analytics_workspace_id` is provided. For some target resource type (e.g., Key Vault), this field is unconfigurable. Please see [resource types](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/azurediagnostics#resource-types) for services that use each method. Please [see the documentation](https://docs.microsoft.com/azure/azure-monitor/platform/diagnostic-logs-stream-log-store#azure-diagnostics-vs-resource-specific) for details on the differences between destination types.<br/>  * `partner_solution_id` - (Optional) The ID of the market partner solution where Diagnostics Data should be sent. For potential partner integrations, [click to learn more about partner integration](https://learn.microsoft.com/en-us/azure/partner-solutions/overview).<br/>  -> **NOTE:** At least one of `eventhub_authorization_rule_id`, `log_analytics_workspace_id`, `partner_solution_id` and `storage_account_id` must be specified.<br/><br/>    An `enabled_log` block supports the following:<br/>    * `category` - (Optional) The name of a Diagnostic Log Category for this Resource.<br/>    -> **NOTE:** The Log Categories available vary depending on the Resource being used. You may wish to use [the `azurerm_monitor_diagnostic_categories` Data Source](../d/monitor\_diagnostic\_categories.html) or [list of service specific schemas](https://docs.microsoft.com/azure/azure-monitor/platform/resource-logs-schema#service-specific-schemas) to identify which categories are available for a given Resource.<br/>    * `category_group` - (Optional) The name of a Diagnostic Log Category Group for this Resource.<br/>    -> **NOTE:** Not all resources have category groups available.<br/>    -> **NOTE:** Exactly one of `category` or `category_group` must be specified.<br/><br/>    A `metric` block supports the following:<br/>    * `category` - (Required) The name of a Diagnostic Metric Category for this Resource.<br/>    * -> **NOTE:** The Metric Categories available vary depending on the Resource being used. You may wish to use [the `azurerm_monitor_diagnostic_categories` Data Source](../d/monitor\_diagnostic\_categories.html) to identify which categories are available for a given Resource.<br/>    * `enabled` - (Optional) Is this Diagnostic Metric enabled? Defaults to `true`.<br/>    * `timeouts` - The `timeouts` block allows you to specify [timeouts](https://www.terraform.io/language/resources/syntax#operation-timeouts) for certain actions:<br/>      * `create` - (Defaults to 30 minutes) Used when creating the Diagnostics Setting.<br/>      * `update` - (Defaults to 30 minutes) Used when updating the Diagnostics Setting.<br/>      * `read` - (Defaults to 5 minutes) Used when retrieving the Diagnostics Setting.<br/>      * `delete` - (Defaults to 60 minutes) Used when deleting the Diagnostics Setting.<br/><br/>  Example Input:<pre>diagnostic_settings = {<br/>    "diagnostic" = {<br/>      name                           = "diagnostic"<br/>      log_analytics_workspace_id     = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/myResourceGroup/providers/Microsoft.OperationalInsights/workspaces/myLogAnalyticsWorkspace"<br/>      storage_account_id             = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/myResourceGroup/providers/Microsoft.Storage/storageAccounts/myStorageAccount"<br/>      log_analytics_destination_type = "Dedicated"<br/>      eventhub_authorization_rule_id = null<br/>      eventhub_name                  = null<br/>      partner_solution_id            = null<br/>      enabled_log = [<br/>        {<br/>          category       = null<br/>          category_group = "allLogs"<br/>        }<br/>      ]<br/>      metric = {<br/>        category = "AllMetrics"<br/>        enabled  = true<br/>      }<br/>      timeouts = {<br/>        create = "30"<br/>        update = "30"<br/>        read   = "5"<br/>        delete = "60"<br/>    }<br/>    }<br/>  }</pre> | <pre>map(object({<br/>    name                           = optional(string)<br/>    log_analytics_workspace_id     = optional(string)<br/>    log_analytics_destination_type = optional(string, "Dedicated")<br/>    storage_account_id             = optional(string)<br/>    eventhub_authorization_rule_id = optional(string)<br/>    eventhub_name                  = optional(string)<br/>    partner_solution_id            = optional(string)<br/>    enabled_log = optional(list(object({<br/>      category       = optional(string)<br/>      category_group = optional(string)<br/>    })))<br/>    metric = optional(object({<br/>      category = optional(string, "AllMetrics")<br/>      enabled  = optional(bool)<br/>    }))<br/>    timeouts = optional(object({<br/>      create = optional(string, "30")<br/>      update = optional(string, "30")<br/>      read   = optional(string, "5")<br/>      delete = optional(string, "60")<br/>    }))<br/>  }))</pre> | `null` | no |
| <a name="input_file_copy_enabled"></a> [file\_copy\_enabled](#input\_file\_copy\_enabled) | * `copy_paste_enabled` - (Optional) Is Copy/Paste feature enabled for the Bastion Host. Defaults to `true`.<br/><br/>  ~> **Note:** `file_copy_enabled` is only supported when `sku` is `Standard` or `Premium`.<br/><br/>  Example Input:<pre>file_copy_enabled = "false"</pre> | `bool` | `true` | no |
| <a name="input_ip_configuration"></a> [ip\_configuration](#input\_ip\_configuration) | * `ip_configuration` - (Optional) A `ip_configuration` block as defined below. Changing this forces a new resource to be created.<br/>  A `ip_configuration` block supports the following:<br/>    * `name` - (Required) The name of the IP configuration. Changing this forces a new resource to be created.<br/>    * `subnet_id` - (Required) Reference to a subnet in which this Bastion Host has been created. Changing this forces a new resource to be created.<br/>    ~> **Note:** The Subnet used for the Bastion Host must have the name `AzureBastionSubnet` and the subnet mask must be at least a `/26`.<br/>    * `public_ip_address_id` - (Required) Reference to a Public IP Address to associate with this Bastion Host. Changing this forces a new resource to be created.<br/><br/>  Example Input:<pre>ip_configuration = {<br/>    name = "myIpConfig"<br/>    subnet_id = "/subscriptions/xxxx/resourceGroups/xxxx/providers/Microsoft.Network/virtualNetworks/myVnet/subnets/AzureBastionSubnet"<br/>    public_ip_address_id = "/subscriptions/xxxx/resourceGroups/xxxx/providers/Microsoft.Network/publicIPAddresses/myPublicIP"<br/>  }</pre> | <pre>object({<br/>    name                 = string<br/>    subnet_id            = string<br/>    public_ip_address_id = string<br/>  })</pre> | `null` | no |
| <a name="input_ip_connect_enabled"></a> [ip\_connect\_enabled](#input\_ip\_connect\_enabled) | * `ip_connect_enabled` - (Optional) Is IP Connect feature enabled for the Bastion Host. Defaults to `false`.<br/><br/>  ~> **Note:** `ip_connect_enabled` is only supported when `sku` is `Standard` or `Premium`.<br/><br/>  Example Input:<pre>ip_connect_enabled = "false"</pre> | `bool` | `false` | no |
| <a name="input_kerberos_enabled"></a> [kerberos\_enabled](#input\_kerberos\_enabled) | * `kerberos_enabled` - (Optional) Is Kerberos authentication feature enabled for the Bastion Host. Defaults to `false`.<br/><br/>  ~> **Note:** `kerberos_enabled` is only supported when `sku` is `Standard` or `Premium`.<br/><br/>  Example Input:<pre>kerberos_enabled = "false"</pre> | `bool` | `false` | no |
| <a name="input_scale_units"></a> [scale\_units](#input\_scale\_units) | * `scale_units` - (Optional) The number of scale units with which to provision the Bastion Host. Possible values are between `2` and `50`. Defaults to `2`.<br/><br/>  ~> **Note:** `scale_units` only can be changed when `sku` is `Standard` or `Premium`. `scale_units` is always `2` when `sku` is `Basic`.<br/><br/>  Example Input:<pre>scale_units = "2"</pre> | `number` | `2` | no |
| <a name="input_session_recording_enabled"></a> [session\_recording\_enabled](#input\_session\_recording\_enabled) | * `session_recording_enabled` - (Optional) Is Session Recording feature enabled for the Bastion Host. Defaults to `false`.<br/><br/>  ~> **Note:** `session_recording_enabled` is only supported when `sku` is `Premium`.<br/><br/>  Example Input:<pre>session_recording_enabled = "false"</pre> | `bool` | `false` | no |
| <a name="input_shareable_link_enabled"></a> [shareable\_link\_enabled](#input\_shareable\_link\_enabled) | * `shareable_link_enabled` - (Optional) Is Shareable Link feature enabled for the Bastion Host. Defaults to `false`.<br/><br/>  ~> **Note:** `shareable_link_enabled` is only supported when `sku` is `Standard` or `Premium`. Example Input:<br/><br/>  Example Input:<pre>shareable_link_enabled = "false"</pre> | `bool` | `false` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | * `sku` - (Optional) The SKU of the Bastion Host. Accepted values are `Developer`, `Basic`, `Standard` and `Premium`. Defaults to `Basic`.<br/><br/>  ~> **Note** Downgrading the SKU will force a new resource to be created.<br/><br/>  Example Input:<pre>sku = "Standard"</pre> | `string` | `"Basic"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | * `tags` - (Optional) A mapping of tags to assign to the resource.<br/><br/>  Example input:<pre>tags = {<br/>    env     = test<br/>    region  = gwc<br/>  }</pre> | `map(string)` | `null` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | The `timeouts` block allows you to specify [timeouts](https://www.terraform.io/language/resources/syntax#operation-timeouts) for certain actions:<br/>    * `create` - (Defaults to 30 minutes) Used when creating the Bastion Host.<br/>    * `read` - (Defaults to 5 minutes) Used when retrieving the Bastion Host.<br/>    * `update` - (Defaults to 30 minutes) Used when updating the Bastion Host.<br/>    * `delete` - (Defaults to 30 minutes) Used when deleting the Bastion Host. | <pre>object({<br/>    create = optional(string, "30")<br/>    read   = optional(string, "5")<br/>    update = optional(string, "30")<br/>    delete = optional(string, "30")<br/>  })</pre> | `null` | no |
| <a name="input_tunneling_enabled"></a> [tunneling\_enabled](#input\_tunneling\_enabled) | * `tunneling_enabled` - (Optional) Is Tunneling feature enabled for the Bastion Host. Defaults to `false`.<br/><br/>  ~> **Note:** `tunneling_enabled` is only supported when `sku` is `Standard` or `Premium`.<pre>Example Input:</pre>tunneling\_enabled = "false"<pre></pre> | `bool` | `false` | no |
| <a name="input_virtual_network_id"></a> [virtual\_network\_id](#input\_virtual\_network\_id) | * `virtual_network_id` - (Optional) The ID of the Virtual Network for the Developer Bastion Host. Changing this forces a new resource to be created.<br/><br/>  ~> **Note:** `session_recording_enabled` is only supported when `sku` is `Premium`.<br/><br/>  Example Input:<pre>virtual_network_id = "/subscriptions/xxxx/resourceGroups/xxxx/providers/Microsoft.Network/virtualNetworks/myVnet"</pre> | `string` | `null` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | * `zones` - (Optional) Specifies a list of Availability Zones in which this Public Bastion Host should be located. Changing this forces a new resource to be created.<br/><br/>  Example Input:<pre>zones = ["1", "2"]</pre> | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_host"></a> [bastion\_host](#output\_bastion\_host) | * `name` – (Required) The name of the Bastion Host.<br/>  * `resource_group_name` – (Required) The name of the Resource Group where the Bastion Host exists.<br/>  * `id` – The ID of the Bastion Host.<br/>  * `location` – The Azure Region where the Bastion Host exists.<br/>  * `copy_paste_enabled` – I Is Copy/Paste feature enabled for the Bastion Host.<br/>  * `file_copy_enabled` – Is File Copy feature enabled for the Bastion Host.<br/>  * `sku` - The SKU of the Bastion Host.<br/>  * `ip_connect_enabled` – Is IP Connect feature enabled for the Bastion Host.<br/>  * `scale_units` – The number of scale units provisioned for the Bastion Host.<br/>  * `shareable_link_enabled` – Is Shareable Link feature enabled for the Bastion Host.<br/>  * `tunneling_enabled` – Is Tunneling feature enabled for the Bastion Host.<br/>  * `session_recording_enabled` – Is Session Recording feature enabled for the Bastion Host.<br/>  * `dns_name` – The FQDN for the Bastion Host.<br/>  * `tags` –A mapping of tags assigned to the Bastion Host.<br/>  * `zones` – A list of Availability Zones in which this Bastion Host is located.<br/><br/>  The `ip_configuration` block supports the following:<br/>      * `name` - The name of the IP configuration.<br/>      * `subnet_id` - Reference to the subnet in which this Bastion Host has been created.<br/>      * `public_ip_address_id` Reference to a Public IP Address associated to this Bastion Host.<br/><br/>  Example output:<pre>output "bastion_dns_name" {<br/>  value = module.bastion.bastion_host.name<br/>  }</pre> |

## Modules

No modules.

## 🌐 Additional Information  

For more information about Azure Bastion and their configurations, refer to the [https://learn.microsoft.com/en-us/azure/bastion/bastion-overview). This module helps you manage Azure Bastion.

## 📚 Resources

- [AzureRM Terraform Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host)
- [Azure Bastion Overview](https://learn.microsoft.com/en-us/azure/bastion/bastion-overview)

## ⚠️ Notes  

- Public IP Requirement: Bastion requires a Standard Public IP attached directly to the Bastion resource (not the VM). Ensure this IP remains available, as removing it will disrupt Bastion access.
- Understand SKU Limitations: Features like file transfer, IP Connect, and session recording are only available with Standard or Premium SKUs. If you select Basic, you will not have access to these features.
- File Transfer and Tunneling: While helpful, features like file transfer and tunneling could introduce security risks if improperly configured. Enable these features only if necessary, and consider additional monitoring to detect unauthorized activity.
- Cost Management: Hourly and Data Transfer Charges: Bastion is billed hourly, plus data transfer costs, which can accumulate over time. Regularly monitor usage and shut down VMs not in active use to avoid unnecessary charges.
- Failover and High Availability: Availability Zones for Redundancy: For production environments, use Availability Zones (Standard SKU) to ensure high availability and minimize downtime. A single zone Bastion Host is vulnerable to outages in that zone.
- Validate your Terraform configuration to ensure that Azure Bastion resources are created and configured correctly, including diagnostic settings and role assignments.

## 🧾 License  

This module is licensed under the MIT License. See the [LICENSE](./LICENSE) file for more details.
<!-- END OF PRE-COMMIT-OPENTOFU DOCS HOOK -->