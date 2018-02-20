provider "openstack" {
  version   = "~> 1.2.0"
  region    = "${var.os_region_name}"
  tenant_id = "${var.os_tenant_id}"
  auth_url  = "${var.os_auth_url}"
}

resource "openstack_networking_secgroup_v2" "sg" {
  name        = "${var.name}_ssh_sg"
  description = "${var.name} security group for cfssl provisionning"
}

resource "openstack_networking_secgroup_rule_v2" "in_traffic_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  port_range_min    = 22
  port_range_max    = 22
  security_group_id = "${openstack_networking_secgroup_v2.sg.id}"
}

module "cfssl" {
  #  source          = "ovh/publiccloud-cfssl/ovh"
  #  version         = ">= 0.0.8"
  source = "../.."

  name                      = "${var.name}"
  region                    = "${var.os_region_name}"
  ssh_authorized_keys       = ["${file(var.public_sshkey)}"]
  image_name                = "Centos 7"
  flavor_name               = "${var.os_flavor_name}"
  ignition_mode             = false
  public_security_group_ids = ["${openstack_networking_secgroup_v2.sg.id}"]
  ssh_user                  = "centos"
  ssh_private_key           = "${file(var.private_sshkey)}"
  post_install_modules      = true
  associate_public_ipv4     = true
  associate_private_ipv4    = false
}
