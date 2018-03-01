variable "image_id" {
  description = "The ID of the glance image to spawn the instance. If `post_install_modules` is set to `false`, this should be an image built from the Packer template under examples/cfssl-glance-image/cfssl.json. If the default value is used, Terraform will look up the latest image build automatically."
  default     = ""
}

variable "image_name" {
  description = "The name of the glance image to spawn the instance. If `post_install_modules` is set to `false`, this should be an image built from the Packer template under examples/cfssl-glance-image/cfssl.json. If the default value is used, Terraform will look up the latest image build automatically."
  default     = "CoreOS Stable"
}

variable "flavor_name" {
  description = "The flavor name that will be used for cfssl nodes."
  default     = "s1-4"
}

variable "name" {
  description = "What to name the cfssl server and all of its associated resources."
}

variable "cidr" {
  description = "The CIDR block of the Network. (e.g. 10.0.0.0/16)"
  default     = ""
}

variable "subnet_id" {
  description = "The subnet id to deploy the cfssl node in."
  default = ""
}

variable "subnet" {
  description = "The subnet to deploy the cfssl node in."
  default = ""
}

variable "security_group_ids" {
  type        = "list"
  description = "An optional list of additional security groups to attach to private ports"
  default     = []
}

variable "public_security_group_ids" {
  type        = "list"
  description = "An optional list of additional security groups to attach to public ports"
  default     = []
}

variable "cacert" {
  description = "Optional ca certificate to add to the nodes. If `cfssl` is set to `true`, cfssl will use `cacert` along with `cakey` to generate certificates. Otherwise will generate a new self signed ca."
  default     = ""
}

variable "cacert_key" {
  description = "Optional ca certificate key. If `cfssl` is set to `true`, cfssl will use `cacert` along with `cakey` to generate certificates. Otherwise will generate a new self signed ca."
  default     = ""
}

variable "ssh_authorized_keys" {
  type        = "list"
  description = "The ssh public keys that can be used to SSH in the instance."
  default     = []
}

variable "post_install_modules" {
  description = "Setting this variable to true will assume the necessary software to boot the server hasn't been packaged in the image and thus will be post provisionned. Defaults to `false`"
  default     = true
}

variable "ssh_user" {
  description = "The ssh username of the image used to boot the cfssl server."
  default     = "core"
}

variable "ssh_private_key" {
  description = "The ssh private key used to post provision the cfssl server. This is required if `post_install_modules` is set to `true`. It must be set accordingly to `ssh_key_pair"
  default     = ""
}

variable "ssh_bastion_host" {
  description = "The address of the bastion host used to post provision the cfssl server. This may be required if `post_install_modules` is set to `true`"
  default     = ""
}

variable "ssh_bastion_user" {
  description = "The ssh username of the bastion host used to post provision the cfssl server. This may be required if `post_install_modules` is set to `true`"
  default     = ""
}

variable "ssh_bastion_private_key" {
  description = "The ssh private key of the bastion host used to post provision the cfssl server. This may be required if `post_install_modules` is set to `true`"
  default     = ""
}

variable "ignition_mode" {
  description = "Set to true if os family supports ignition, such as CoreOS/Container Linux distribution"
  default     = true
}

variable "cfssl_version" {
  description = "The version of cfssl to install with the post installation script if `post_install_modules` is set to true"
  default     = "1.0.2"
}

variable "cfssl_sha256sum" {
  description = "The sha256 checksum of the cfssl binary to install with the post installation script if `post_install_modules` is set to true"
  default     = "418329f0f4fc3f18ef08674537b576e57df3f3026f258794b4b4b611beae6c9b"
}

variable "associate_public_ipv4" {
  description = "Associate a public ipv4 with the cfssl nodes"
  default     = false
}

variable "associate_private_ipv4" {
  description = "Associate a private ipv4 with the cfssl nodes"
  default     = true
}

variable "ca_validity_period" {
  description = "validity period for generated CA"
  default     = "43800h"
}

variable "cert_validity_period" {
  description = "default validity period for generated certs"
  default     = "8760h"
}

variable "cn" {
  description = "generated certs common name field "
  default     = ""
}

variable "c" {
  description = "generated certs country field"
  default     = ""
}

variable "l" {
  description = "generated certs location field"
  default     = "Roubaix"
}

variable "o" {
  description = "generated certs org field"
  default     = "myorg"
}

variable "ou" {
  description = "generated certs ou field"
  default     = "59"
}

variable "st" {
  description = "generated certs state field"
  default     = "Nord"
}

variable "key_algo" {
  description = "generated certs key algo. ECDSA seems to be incompatible with some distros. Choose with caution."
  default     = "rsa"
}

variable "key_size" {
  description = "generated certs key size"
  default     = "2048"
}

variable "bind" {
  description = "cfssl service bind addr"
  default     = "0.0.0.0"
}

variable "port" {
  description = "cfssl service bind port"
  default     = "8888"
}
