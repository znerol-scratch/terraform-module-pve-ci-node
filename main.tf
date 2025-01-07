/**
 * Creates a Proxmox VE node on a qemu/libvirt hybervisor for ci purposes.
 *
 * ## Usage:
 *
 * ```hcl
 * module "pve_ci_node" {
 *   source = "github.com/znerol-scratch/terraform-module-pve-ci-node"
 * }
 * ```
 */

locals {
  nodename               = var.nodename == "" ? var.name_prefix : var.nodename
  address                = libvirt_domain.node.network_interface[0].addresses[0]
  use_generated_keypair  = var.ssh_private_key == "" || var.ssh_public_key == ""
  ssh_public_key         = local.use_generated_keypair ? tls_private_key.keypair[0].public_key_openssh : var.ssh_public_key
  ssh_private_key        = local.use_generated_keypair ? tls_private_key.keypair[0].private_key_openssh : var.ssh_private_key
  use_generated_password = var.password_hash == ""
  password_hash          = local.use_generated_password ? random_password.root[0].bcrypt_hash : var.password_hash
}

resource "tls_private_key" "keypair" {
  count     = local.use_generated_keypair ? 1 : 0
  algorithm = "ED25519"
}

resource "random_password" "root" {
  count  = local.use_generated_password ? 1 : 0
  length = 16
}

resource "libvirt_cloudinit_disk" "ci" {
  name = "${var.name_prefix}_cloudinit.iso"
  pool = var.libvirt_pool_name
  user_data = templatefile("${path.module}/provision/cloud-init.cfg.tftpl", {
    ssh_public_key = local.ssh_public_key
    password_hash  = local.password_hash
  })
}

resource "libvirt_volume" "base" {
  name   = "${var.name_prefix}_base"
  pool   = var.libvirt_pool_name
  source = "https://cdimage.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
}

resource "libvirt_volume" "root" {
  name           = "${var.name_prefix}_root"
  pool           = var.libvirt_pool_name
  base_volume_id = libvirt_volume.base.id
  size           = 21474836480
}

resource "libvirt_domain" "node" {
  name       = var.name_prefix
  machine    = "q35"
  cloudinit  = libvirt_cloudinit_disk.ci.id
  memory     = 2048
  vcpu       = 2
  qemu_agent = true
  xml {
    xslt = file("${path.module}/libvirt-domain.xsl")
  }
  cpu {
    mode = "host-passthrough"
  }
  disk {
    volume_id = libvirt_volume.root.id
    scsi      = true
  }
  network_interface {
    network_name   = var.libvirt_network_name
    hostname       = local.nodename
    wait_for_lease = true
  }
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      templatefile("${path.module}/provision/setup-hostname.sh.tftpl", {
        hostname = local.nodename
        ipv4     = self.network_interface[0].addresses[0]
      }),
      file("${path.module}/provision/install-pve.sh"),
      file("${path.module}/provision/setup-interfaces-sdn.sh")
    ]
    connection {
      type        = "ssh"
      user        = "debian"
      private_key = local.ssh_private_key
      host        = self.network_interface[0].addresses[0]
    }
  }
}
