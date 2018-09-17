data "template_file" "cfssl_ca_files" {
  template = <<TPL
- path: /opt/cfssl/cacert/ca.pem
  permissions: '0644'
  owner: cfssl:cfssl
  content: |
     ${indent(5, var.cacert)}
- path: /opt/cfssl/cacert/ca-key.pem
  permissions: '0600'
  owner: cfssl:cfssl
  content: |
     ${indent(5, var.cacert_key)}
TPL
}

# Render a multi-part cloudinit config making use of the part
# above, and other source files
data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"

    content = <<CLOUDCONFIG
#cloud-config
## This route has to be added in order to reach other subnets of the network
ssh_authorized_keys:
  ${length(var.ssh_authorized_keys) > 0 ? indent(2, join("\n", formatlist("- %s", var.ssh_authorized_keys))) : ""}
bootcmd:
  ${var.cidr != "" ? indent(2, format(local.ip_route_add_tpl, var.cidr, "eth0")) : "- echo nothing to do"}
ca-certs:
  trusted:
    - ${var.cacert}
write_files:
  ${var.cacert != "" && var.cacert_key != "" ? indent(2, data.template_file.cfssl_ca_files.rendered) : ""}
  - path: /etc/sysconfig/cfssl.conf
    mode: 0644
    content: |
      ${indent(6, data.template_file.conf.rendered)}
  - path: /etc/sysconfig/network-scripts/route-eth0
    content: |
      ${var.cidr != "" ? indent(6, format(local.eth_route_tpl, var.cidr, "eth0")) : ""}
CLOUDCONFIG
  }
}
