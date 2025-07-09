output "bastion_host" {
  value       = azurerm_bastion_host.this
  description = <<DESCRIPTION
  * `name` – (Required) The name of the Bastion Host.
  * `resource_group_name` – (Required) The name of the Resource Group where the Bastion Host exists.
  * `id` – The ID of the Bastion Host.
  * `location` – The Azure Region where the Bastion Host exists.
  * `copy_paste_enabled` – I Is Copy/Paste feature enabled for the Bastion Host.
  * `file_copy_enabled` – Is File Copy feature enabled for the Bastion Host.
  * `sku` - The SKU of the Bastion Host.
  * `ip_connect_enabled` – Is IP Connect feature enabled for the Bastion Host.
  * `scale_units` – The number of scale units provisioned for the Bastion Host.
  * `shareable_link_enabled` – Is Shareable Link feature enabled for the Bastion Host.
  * `tunneling_enabled` – Is Tunneling feature enabled for the Bastion Host.
  * `session_recording_enabled` – Is Session Recording feature enabled for the Bastion Host.
  * `dns_name` – The FQDN for the Bastion Host.
  * `tags` –A mapping of tags assigned to the Bastion Host.
  * `zones` – A list of Availability Zones in which this Bastion Host is located.

  The `ip_configuration` block supports the following:
      * `name` - The name of the IP configuration.
      * `subnet_id` - Reference to the subnet in which this Bastion Host has been created.
      * `public_ip_address_id` Reference to a Public IP Address associated to this Bastion Host.

  Example output:
  ```
  output "bastion_dns_name" {
  value = module.bastion.bastion_host.name
  }
   ```
  DESCRIPTION
}
