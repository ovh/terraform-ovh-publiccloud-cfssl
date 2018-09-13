variable "name" {
  description = "The name of the setup. This attribute will be used to name openstack resources"
  default     = "mycfssl"
}

variable "region" {
  description = "The id of the openstack region"
  default     = "GRA3"
}

variable "public_sshkey" {
  description = "Key to use to ssh connect"
  default     = ""
}

variable "key_pair" {
  description = "Predefined keypair to use"
  default     = ""
}

variable "remote_ip_prefix" {
  description = "The remote IPv4 prefix used to filter kubernetes API and ssh remote traffic. If left blank, the public NATed IPv4 of the user will be used."
  default     = ""
}
