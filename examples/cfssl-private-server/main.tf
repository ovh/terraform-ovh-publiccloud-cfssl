provider "openstack" {
  version   = "~> 1.2.0"
  region    = "${var.os_region_name}"
  tenant_id = "${var.os_tenant_id}"
  auth_url  = "${var.os_auth_url}"
}

module "network" {
  source  = "ovh/publiccloud-network/ovh"
  version = ">= 0.1.0"

  name           = "${var.name}"
  cidr           = "${var.cidr}"
  region         = "${var.os_region_name}"

  # one public subnet for nats & bastion instances
  public_subnets = ["${cidrsubnet(var.cidr, 4, 0)}"]

  # one priv for cfssl private instance
  private_subnets    = ["${cidrsubnet(var.cidr, 4, 1)}"]
  enable_nat_gateway = true
  single_nat_gateway = true
  nat_as_bastion     = true
  ssh_public_keys    = ["${file("${var.public_sshkey}")}"]
}

module "cfssl" {
  #  source          = "ovh/publiccloud-cfssl/ovh"
  #  version         = ">= 0.0.8"
  source = "../.."

  name                    = "${var.name}"
  region                  = "${var.os_region_name}"
  ssh_authorized_keys     = ["${file(var.public_sshkey)}"]
  subnet_id               = "${module.network.private_subnets[0]}"
  image_name              = "Centos 7"
  flavor_name             = "${var.os_flavor_name}"
  ignition_mode           = false
  post_install_modules    = true
  ssh_user                = "centos"
  ssh_private_key         = "${file(var.private_sshkey)}"
  ssh_bastion_private_key = "${file("${var.private_sshkey}")}"
  ssh_bastion_host        = "${module.network.bastion_public_ip}"
  ssh_bastion_user        = "core"
}
