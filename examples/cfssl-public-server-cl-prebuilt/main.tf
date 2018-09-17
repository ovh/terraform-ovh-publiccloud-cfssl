provider "openstack" {
  version   = "~> 1.2.0"
  region    = "${var.region}"
}

data "http" "myip" {
  url = "https://api.ipify.org/"
}

resource "openstack_networking_secgroup_v2" "sg" {
  name        = "${var.name}_ssh_sg"
  description = "${var.name} security group for cfssl provisionning"
}

resource "openstack_networking_secgroup_rule_v2" "in_traffic_cfssl" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "${var.remote_ip_prefix == "" ? format("%s/32", data.http.myip.body) : var.remote_ip_prefix}"
  port_range_min    = 8888
  port_range_max    = 8888
  security_group_id = "${openstack_networking_secgroup_v2.sg.id}"
}

module "cfssl" {
  #  source          = "ovh/publiccloud-cfssl/ovh"
  #  version         = ">= 0.0.8"
  source = "../.."

  name                      = "${var.name}"
  image_name                = "CoreOS Stable Cfssl"
  flavor_name               = "${var.os_flavor_name}"
  associate_public_ipv4     = true
  associate_private_ipv4    = false
  post_install_modules      = false
}
