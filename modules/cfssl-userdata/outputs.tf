output "rendered" {
  description = "The representation of the userdata according to `var.ignition_mode`"
  value = "${var.ignition_mode ? data.ignition_config.coreos.rendered : data.template_cloudinit_config.config.rendered}"
}

output "conf" {
  description = "The configuration to be installed in /etc/sysconfig/cfssl.conf"
  value = "${data.template_file.conf.rendered}"
}

output "endpoint" {
  description = "The cfssl endpoint"
  value = "${local.cfssl_endpoint}"
}
