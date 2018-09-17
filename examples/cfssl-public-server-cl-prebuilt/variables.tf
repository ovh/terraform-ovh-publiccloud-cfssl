variable "region" {
  description = "The Openstack region name"
  default     = ""
}

variable "os_flavor_name" {
  description = "Flavor to use"
  default     = "s1-2"
}

variable "name" {
  description = "The name of the setup. This attribute will be used to name openstack resources"
  default     = "mycfssl"
}

variable "remote_ip_prefix" {
  description = "The remote IPv4 prefix used to filter cfssl remote traffic. If left blank, the public NATed IPv4 of the user will be used."
  default     = ""
}
