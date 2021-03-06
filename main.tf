terraform {
  required_version = ">= 0.9.3"
}

# NOTE: This Terraform data source must return at least one Image result or the entire template will fail.
data "openstack_images_image_v2" "cfssl" {
  count       = "${var.image_id == "" ? 1 : 0}"
  name        = "${var.image_name}"
  most_recent = true
}

data "openstack_networking_subnet_v2" "subnet" {
  count        = "${var.associate_private_ipv4 ? 1 : 0}"
  subnet_id    = "${var.subnet_id}"
  cidr         = "${var.subnet}"
  ip_version   = 4
  dhcp_enabled = true
}

data "openstack_networking_network_v2" "ext_net" {
  name      = "Ext-Net"
  tenant_id = ""
}

resource "openstack_networking_secgroup_v2" "servers_sg" {
  count       = "${var.associate_private_ipv4 ? 1 : 0}"
  name        = "${var.name}_sg"
  description = "${var.name} security group for cfssl"
}

resource "openstack_networking_secgroup_rule_v2" "in_traffic_tcp" {
  count             = "${var.associate_private_ipv4 ? 1 : 0}"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "${var.cidr}"
  security_group_id = "${openstack_networking_secgroup_v2.servers_sg.id}"
}

resource "openstack_networking_secgroup_rule_v2" "in_traffic_udp" {
  count             = "${var.associate_private_ipv4 ? 1 : 0}"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  remote_ip_prefix  = "${var.cidr}"
  security_group_id = "${openstack_networking_secgroup_v2.servers_sg.id}"
}

resource "openstack_networking_secgroup_v2" "public_servers_sg" {
  count       = "${var.associate_public_ipv4 ? 1 : 0}"
  name        = "${var.name}_pub_sg"
  description = "${var.name} security group for public ingress traffic on cfssl hosts"
}

resource "openstack_networking_secgroup_rule_v2" "in_traffic_cfssl" {
  count             = "${var.associate_public_ipv4 ? 1 : 0}"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  port_range_min    = "${var.port}"
  port_range_max    = "${var.port}"
  security_group_id = "${openstack_networking_secgroup_v2.public_servers_sg.id}"
}

resource "openstack_networking_port_v2" "public_port_cfssl" {
  count = "${var.associate_public_ipv4 ? 1 : 0}"
  name  = "${var.name}_cfssl_public_port"

  network_id     = "${data.openstack_networking_network_v2.ext_net.id}"
  admin_state_up = "true"

  security_group_ids = [
    "${compact(concat(openstack_networking_secgroup_v2.public_servers_sg.*.id,var.public_security_group_ids))}",
  ]
}

data "template_file" "public_ipv4_addr" {
  count    = "${var.associate_public_ipv4 ? 1 : 0}"

  # join all ips as string > remove every ipv6 > split & compact
  template = "${join("", compact(split(",", replace(join(",", flatten(openstack_networking_port_v2.public_port_cfssl.*.all_fixed_ips)), "/[[:alnum:]]+:[^,]+/", ""))))}"
}

resource "openstack_networking_port_v2" "port_cfssl" {
  count          = "${var.associate_private_ipv4 ? 1 : 0}"
  name           = "${var.name}_cfssl_port"
  network_id     = "${data.openstack_networking_subnet_v2.subnet.network_id}"
  admin_state_up = "true"

  security_group_ids = [
    "${compact(concat(list(openstack_networking_secgroup_v2.servers_sg.id),var.security_group_ids))}",
  ]

  fixed_ip {
    subnet_id = "${data.openstack_networking_subnet_v2.subnet.id}"
  }
}

data "template_file" "private_ipv4_addr" {
  count    = "${var.associate_private_ipv4 ? 1 : 0}"
  template = "${join("", compact(split(",", replace(join(",", flatten(openstack_networking_port_v2.port_cfssl.*.all_fixed_ips)), "/[[:alnum:]]+:[^,]+/", ""))))}"
}

module "userdata" {
  source              = "./modules/cfssl-userdata"
  ignition_mode       = "${var.ignition_mode}"
  cidr                = "${var.cidr}"
  ssh_authorized_keys = ["${var.ssh_authorized_keys}"]
  ipv4_addr           = "${var.associate_private_ipv4 ? join("", data.template_file.private_ipv4_addr.*.rendered) : join("", data.template_file.public_ipv4_addr.*.rendered) }"

  cacert               = "${var.cacert}"
  cacert_key           = "${var.cacert_key}"
  ca_validity_period   = "${var.ca_validity_period}"
  cert_validity_period = "${var.cert_validity_period}"
  cn                   = "${var.cn}"
  c                    = "${var.c}"
  l                    = "${var.l}"
  o                    = "${var.o}"
  ou                   = "${var.ou}"
  st                   = "${var.st}"
  key_algo             = "${var.key_algo}"
  key_size             = "${var.key_size}"
  bind                 = "${var.bind}"
  port                 = "${var.port}"
}

resource "openstack_compute_instance_v2" "multinet_cfssl" {
  count    = "${var.associate_public_ipv4 && var.associate_private_ipv4? 1 : 0}"
  name     = "${var.name}"
  image_id = "${element(coalescelist(data.openstack_images_image_v2.cfssl.*.id, list(var.image_id)), 0)}"

  flavor_name = "${var.flavor_name}"
  user_data   = "${module.userdata.rendered}"

  network {
    port = "${join("", openstack_networking_port_v2.port_cfssl.*.id)}"
  }

  # Important: orders of network declaration matters because public internet interface must be eth1
  network {
    access_network = true
    port           = "${join("", openstack_networking_port_v2.public_port_cfssl.*.id)}"
  }
}

resource "openstack_compute_instance_v2" "singlenet_cfssl" {
  count    = "${! (var.associate_public_ipv4 && var.associate_private_ipv4) ? 1 : 0}"
  name     = "${var.name}"
  image_id = "${element(coalescelist(data.openstack_images_image_v2.cfssl.*.id, list(var.image_id)), 0)}"

  flavor_name = "${var.flavor_name}"
  user_data   = "${module.userdata.rendered}"

  network {
    access_network = true
    port           = "${join("", coalescelist(openstack_networking_port_v2.port_cfssl.*.id, openstack_networking_port_v2.public_port_cfssl.*.id))}"
  }
}

module "post_install_cfssl" {
  source                  = "./modules/install-cfssl"
  count                   = "${var.post_install_modules ? 1 : 0}"
  triggers                = ["${join("", coalescelist(openstack_compute_instance_v2.multinet_cfssl.*.id, openstack_compute_instance_v2.singlenet_cfssl.*.id))}"]
  ipv4_addrs              = ["${join("", coalescelist(openstack_compute_instance_v2.multinet_cfssl.*.access_ip_v4, openstack_compute_instance_v2.singlenet_cfssl.*.access_ip_v4))}"]
  ssh_user                = "${var.ssh_user}"
  ssh_bastion_host        = "${var.ssh_bastion_host}"
  ssh_bastion_user        = "${var.ssh_bastion_user}"
}
