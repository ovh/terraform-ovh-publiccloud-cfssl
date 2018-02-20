data "ignition_file" "cacert" {
  count      = "${var.cacert != "" ? 1 : 0}"
  filesystem = "root"
  path       = "/etc/ssl/certs/ca.pem"
  mode       = "0644"

  content {
    content = "${var.cacert}"
  }
}

data "ignition_file" "cfssl-cacert" {
  count      = "${var.cacert != "" ? 1 : 0}"
  filesystem = "root"
  path       = "/opt/cfssl/cacert/ca.pem"
  mode       = "0644"

  content {
    content = "${var.cacert}"
  }
}

data "ignition_file" "cfssl-cakey" {
  count      = "${var.cacert_key != "" ? 1 : 0}"
  filesystem = "root"
  path       = "/opt/cfssl/cacert/ca-key.pem"
  mode       = "0600"
  uid        = "1011"

  content {
    content = "${var.cacert_key}"
  }
}

data "ignition_file" "conf" {
  filesystem = "root"
  mode       = "0644"
  path       = "/etc/sysconfig/cfssl.conf"

  content {
    content = "${data.template_file.conf.rendered}"
  }
}

data "ignition_networkd_unit" "eth0" {
  name = "10-eth0.network"

  content = <<IGNITION
[Match]
Name=eth0
[Network]
DHCP=ipv4
${var.cidr != "" ? format(local.network_route_tpl, var.cidr) : ""}
[DHCP]
RouteMetric=2048
IGNITION
}

data "ignition_networkd_unit" "eth1" {
  name = "10-eth1.network"

  content = <<IGNITION
[Match]
Name=eth1
[Network]
DHCP=ipv4
[DHCP]
RouteMetric=2048
IGNITION
}

data "ignition_user" "core" {
  name                = "core"
  ssh_authorized_keys = ["${var.ssh_authorized_keys}"]
}

data "ignition_config" "coreos" {
  users = ["${data.ignition_user.core.id}"]

  networkd = [
    "${data.ignition_networkd_unit.eth0.id}",
    "${data.ignition_networkd_unit.eth1.id}",
  ]

  files = [
    "${data.ignition_file.cacert.*.id}",
    "${data.ignition_file.cfssl-cacert.*.id}",
    "${data.ignition_file.cfssl-cakey.*.id}",
    "${data.ignition_file.conf.id}",
  ]
}
