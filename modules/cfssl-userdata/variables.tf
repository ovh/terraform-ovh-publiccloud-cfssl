variable "cidr" {
  description = "The cidr of the network"
  default     = ""
}

variable "ignition_mode" {
  description = "Defines if main output is in ignition or cloudinit format"
  default     = true
}

variable "ssh_authorized_keys" {
  type        = "list"
  description = "The ssh public keys that can be used to SSH to the instance."
  default     = []
}

variable "cacert" {
  description = "Optional ca certificate to install on the instance."
  default     = ""
}

variable "cacert_key" {
  description = "Optional ca certificate to use in conjunction with `cacert` for generating certs instead of generating a selft signed ca."
  default     = ""
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
  description = "generated certs key algo"
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

variable "ipv4_addr" {
  description = "instance ipv4 addr."
}
