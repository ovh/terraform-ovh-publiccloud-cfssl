provider "openstack" {
  version = "~> 1.5.0"
  region  = "${var.region}"
}

data "http" "myip" {
  url = "https://api.ipify.org/"
}

resource "openstack_networking_secgroup_v2" "sg" {
  name        = "${var.name}_ssh_sg"
  description = "${var.name} security group for cfssl provisionning"
}

resource "openstack_networking_secgroup_rule_v2" "in_traffic_ssh_master" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "${var.remote_ip_prefix == "" ? format("%s/32", data.http.myip.body) : var.remote_ip_prefix}"
  port_range_min    = 22
  port_range_max    = 22
  security_group_id = "${openstack_networking_secgroup_v2.sg.id}"
}

module "cfssl" {
  #  source          = "ovh/publiccloud-cfssl/ovh"
  #  version         = ">= 0.0.8"
  source = "../.."

  name                      = "${var.name}"
  ssh_authorized_keys       = ["${file(var.public_sshkey == "" ? "/dev/null" : var.public_sshkey)}"]
  image_name                = "Ubuntu 16.04"
  flavor_name               = "s1-2"
  ignition_mode             = false
  public_security_group_ids = ["${openstack_networking_secgroup_v2.sg.id}"]
  ssh_user                  = "ubuntu"
  post_install_modules      = true
  associate_public_ipv4     = true
  associate_private_ipv4    = false
}
