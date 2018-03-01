provider "openstack" {
  version   = "~> 1.2.0"
  region    = "${var.os_region_name}"
  tenant_id = "${var.os_tenant_id}"
  auth_url  = "${var.os_auth_url}"
}


# we explicitly don't set any ssh authorized key on the module,
# and we don't open any public ssh access port to illustrate
# that it could be quite easy to boot an immutable cfssl server.
# Yet, as this module has no support for HA, we recommend
# users to backup the server data regularly, as it contains
# at least the CA keypair.

module "cfssl" {
  #  source          = "ovh/publiccloud-cfssl/ovh"
  #  version         = ">= 0.0.8"
  source = "../.."

  name                      = "${var.name}"
  image_name                = "Centos 7 Cfssl"
  flavor_name               = "${var.os_flavor_name}"
  ignition_mode             = false
  associate_public_ipv4     = true
  associate_private_ipv4    = false
  post_install_modules      = false
}
