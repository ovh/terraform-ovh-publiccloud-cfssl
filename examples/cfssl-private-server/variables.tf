variable "os_region_name" {
  description = "The Openstack region name"
  default     = ""
}

variable "os_tenant_id" {
  description = "The id of the openstack project"
  default     = ""
}

variable "os_auth_url" {
  description = "The OpenStack auth url"
  default     = "https://auth.cloud.ovh.net/v2.0/"
}

variable "os_flavor_name" {
  description = "Flavor to use"
  default     = "b2-7"
}

variable "cidr" {
  description = "The cidr of the network for hosts (namely openstack instances)"
  default     = "10.137.0.0/16"
}

variable "name" {
  description = "The name of the resources. This attribute will be used to name openstack resources"
  default     = "mycfssl"
}

variable "private_sshkey" {
  description = "Key to use to ssh connect"
  default     = "~/.ssh/id_rsa"
}

variable "public_sshkey" {
  description = "Key to use to ssh connect"
  default     = "~/.ssh/id_rsa.pub"
}
