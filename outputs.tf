output "security_group_id" {
  value = "${join( "", openstack_networking_secgroup_v2.servers_sg.*.id)}"
}

output "public_security_group_id" {
  value = "${join("", openstack_networking_secgroup_v2.public_servers_sg.*.id)}"
}

output "private_ipv4_addr" {
  value = "${join( "", data.template_file.private_ipv4_addr.*.rendered)}"
}

output "public_ipv4_addr" {
  value = "${join( "", data.template_file.public_ipv4_addr.*.rendered)}"
}

output "endpoint" {
  value = "${module.userdata.endpoint}"
}

output "private_endpoint" {
  value = "${var.associate_private_ipv4 ? format("https://%s:8888", join("", data.template_file.private_ipv4_addr.*.rendered)) : ""}"
}

output "public_endpoint" {
  value = "${var.associate_public_ipv4 ? format("https://%s:8888", join("", data.template_file.public_ipv4_addr.*.rendered)) : ""}"
}
