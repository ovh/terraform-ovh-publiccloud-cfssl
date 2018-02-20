locals {
  network_route_tpl = "[Route]\nDestination=%s\nGatewayOnLink=yes\nRouteMetric=3\nScope=link\nProtocol=kernel"
  cfssl_endpoint    = "${format("https://%s:8888", var.ipv4_addr)}"
  ip_route_add_tpl  = "- ip route add %s dev %s scope link metric 0"
  eth_route_tpl     = "%s dev %s scope link metric 0"
}

data "template_file" "conf" {
  template = <<CONTENT
CA_VALIDITY_PERIOD=${var.ca_validity_period}
CERT_VALIDITY_PERIOD=${var.cert_validity_period}
CN=${var.cn}
C=${var.c}
L=${var.l}
O=${var.o}
OU=${var.ou}
ST=${var.st}
KEY_ALGO=${var.key_algo}
KEY_SIZE=${var.key_size}
CFSSL_BIND=${var.bind}
CFSSL_PORT=${var.port}
CONTENT
}
