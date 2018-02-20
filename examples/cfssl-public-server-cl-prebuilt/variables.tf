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
  default     = "s1-2"
}

variable "name" {
  description = "The name of the setup. This attribute will be used to name openstack resources"
  default     = "mycfssl"
}
