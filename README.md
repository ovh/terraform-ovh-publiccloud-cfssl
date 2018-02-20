# Cfssl OVH Public Cloud Module

This repo contains a Module for how to deploy a [Cfssl](https://cfssl.org/) server on [OVH Public Cloud](https://ovhcloud.com/) using [Terraform](https://www.terraform.io/). Cfssl is the Cloudflare's PKI and TLS toolkit. You can use this module to typically generate your own CA and TLS keypairs for your cluster nodes, such as etcd, consul, ....

# Usage


```hcl
module "cfssl" {
  source          = "ovh/publiccloud-cfssl/ovh"

  name                      = "mypki"
  region                    = "GRA3""
  image_name                = "CoreOS Stable Cfssl"
  associate_public_ipv4     = true
  associate_private_ipv4    = false
  post_install_modules      = false
}
```

## Examples

This module has the following folder structure:

* [root](.): This folder shows an example of Terraform code which deploys a [Cfssl](https://cfssl.org/) server in [OVH Public Cloud](https://ovhcloud.com/).
* [modules](https://github.com/ovh/terraform-ovh-publiccloud-cfssl/tree/master/modules): This folder contains the reusable code for this Module, broken down into one or more modules.
* [examples](https://github.com/ovh/terraform-ovh-publiccloud-cfssl/tree/master/examples): This folder contains examples of how to use the modules.

To deploy a Cfssl server using this Module:	

1. (Optional) Create a Cfssl Glance Image using a Packer template that references the [install-cfssl module](https://github.com/ovh/terraform-ovh-publiccloud-cfssl/tree/master/modules/install-cfssl).
   Here is an [example Packer template](https://github.com/ovh/terraform-ovh-publiccloud-cfssl/tree/master/examples/cfssl-glance-image#quick-start). 
      
1. Deploy that Image using the Terraform [cfssl-public-server example](https://github.com/ovh/terraform-ovh-publiccloud-cfssl/tree/master/examples/cfssl-public-server). If you prebuilt a cfssl glance image with packer, you can comment the post provisionning modules arguments.

## How do I contribute to this Module?

Contributions are very welcome! Check out the [Contribution Guidelines](https://github.com/ovh/terraform-ovh-publiccloud-cfssl/tree/master/CONTRIBUTING.md) for instructions.

## Authors

Module managed by [Yann Degat](https://github.com/yanndegat).

## License

The 3-Clause BSD License. See [LICENSE](https://github.com/ovh/terraform-ovh-publiccloud-cfssl/tree/master/LICENSE) for full details.
