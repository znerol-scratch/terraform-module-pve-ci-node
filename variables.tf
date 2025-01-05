variable "name_prefix" {
  type        = string
  default     = "pve-ci-node"
  description = "Name prefix used for all libvirt resources (domain, image, base image, cloud-init iso)."
}

variable "ssh_private_key" {
  type        = string
  default     = ""
  description = "SSH private key to be used to provision the node. A new keypair is generated and stored in terraform state if omitted."
}

variable "ssh_public_key" {
  type        = string
  default     = ""
  description = "SSH public key added to the default cloud-init account. A new keypair is generated and stored in terraform state if omitted."
}

variable "password_hash" {
  type        = string
  default     = ""
  description = "Hash of root password used to login to the PVE web interface. A password is generated if omitted."
}

variable "nodename" {
  type        = string
  default     = ""
  description = "Hostname to set before PVE is installed. Defaults to `name_prefix`."
}

variable "libvirt_connect_uri" {
  type        = string
  default     = "qemu:///system"
  description = "Connect string for libvirt."
}

variable "libvirt_network_name" {
  type        = string
  default     = "default"
  description = "Network to connect the libvirt PVE node to."
}

variable "libvirt_pool_name" {
  type        = string
  default     = "default"
  description = "Storage pool to use for libvirt images."
}
