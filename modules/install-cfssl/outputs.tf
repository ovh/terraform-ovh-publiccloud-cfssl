output "install_id" {
  description = "The id of post install step"
  value       = "${join("", null_resource.post_install.*.id)}"
}
