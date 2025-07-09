<!-- BEGIN_TF_DOCS -->
# azurerm_bastion_host Module

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
