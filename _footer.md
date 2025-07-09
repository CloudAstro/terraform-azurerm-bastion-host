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
