Creates a Proxmox VE node on a qemu/libvirt hybervisor for ci purposes.

## Usage:

```hcl
module "pve_ci_node" {
  source = "github.com/znerol-scratch/terraform-module-pve-ci-node"
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_libvirt"></a> [libvirt](#provider\_libvirt) | 0.8.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.6 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [libvirt_cloudinit_disk.ci](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/cloudinit_disk) | resource |
| [libvirt_domain.node](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/domain) | resource |
| [libvirt_volume.base](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/volume) | resource |
| [libvirt_volume.root](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/volume) | resource |
| [random_password.root](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [tls_private_key.keypair](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_libvirt_connect_uri"></a> [libvirt\_connect\_uri](#input\_libvirt\_connect\_uri) | Connect string for libvirt. | `string` | `"qemu:///system"` | no |
| <a name="input_libvirt_network_name"></a> [libvirt\_network\_name](#input\_libvirt\_network\_name) | Network to connect the libvirt PVE node to. | `string` | `"default"` | no |
| <a name="input_libvirt_pool_name"></a> [libvirt\_pool\_name](#input\_libvirt\_pool\_name) | Storage pool to use for libvirt images. | `string` | `"default"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name prefix used for all libvirt resources (domain, image, base image, cloud-init iso). | `string` | `"pve-ci-node"` | no |
| <a name="input_nodename"></a> [nodename](#input\_nodename) | Hostname to set before PVE is installed. Defaults to `name_prefix`. | `string` | `""` | no |
| <a name="input_password_hash"></a> [password\_hash](#input\_password\_hash) | Hash of root password used to login to the PVE web interface. A password is generated if omitted. | `string` | `""` | no |
| <a name="input_ssh_private_key"></a> [ssh\_private\_key](#input\_ssh\_private\_key) | SSH private key to be used to provision the node. A new keypair is generated and stored in terraform state if omitted. | `string` | `""` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | SSH public key added to the default cloud-init account. A new keypair is generated and stored in terraform state if omitted. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_node_url"></a> [node\_url](#output\_node\_url) | Web URL of the PVE manager. |
| <a name="output_password"></a> [password](#output\_password) | Generated initial root password. Empty if password hash was supplied as input. |
