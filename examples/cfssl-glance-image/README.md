# Cfssl Glance Image

This folder shows an example of how to use the [install-cfssl](../../modules/install-cfssl) and [install-dnsmasq](../..//modules/install-dnsmasq) modules with [Packer](https://www.packer.io/) to create an [an Openstack Glance Image](https://docs.openstack.org/glance/latest/) that has Cfssl and Dnsmasq installed on top of CensOS 7.

This image will have [Cfssl](https://www.cfssl.io/) installed. To see how to deploy this image, check out the [module's main script](../../README.md). 

For more info on Cfssl installation and configuration, check out the [install-cfssl](../../modules/install-cfssl) documentation.

## Quick start

To build the Cfssl Glance Image:

1. `git clone` this repo to your computer.
1. Install [Packer](https://www.packer.io/).
1. Configure your Openstack credentials using one of the [options supported by the Openstack API](https://developer.openstack.org/api-guide/quick-start/api-quick-start.html). 
1. Update the `variables` section of the `cfssl.json` Packer template to configure the Openstack region, Cfssl version, and Dnsmasq version you wish to use.
1. Run `packer build centos7-cfssl.json`.
1. Or run `make centos7-cfssl`.

When the build finishes, it will output the ID of the new Glance Image. To see how to deploy this image, check out the [module's main script](../../README.md).


## Creating your own Packer template for production usage

When creating your own Packer template for production usage, you can copy the example in this folder more or less exactly, except for one change: we recommend replacing the `file` provisioner with a call to `git clone` in the `shell` provisioner. Instead of:

```json
{
  "provisioners": [{
    "type": "file",
    "source": "{{template_dir}}/../../../terraform-ovh-publiccloud-cfssl",
    "destination": "/tmp"
  },{
    "type": "shell",
    "inline": [
      "/tmp/terraform-ovh-publiccloud-cfssl/modules/install-cfssl/install-cfssl --version {{user `cfssl_version`}}",
      "/tmp/terraform-ovh-publiccloud-cfssl/modules/install-dnsmasq/install-dnsmasq"
    ],
    "pause_before": "30s"
  }]
}
```

Your code should look more like this:

```json
{
  "provisioners": [{
    "type": "shell",
    "inline": [
      "git clone --branch <MODULE_VERSION> https://github.com/ovh/terraform-ovh-publiccloud-cfssl.git /tmp/terraform-ovh-publiccloud-cfssl",
      "/tmp/terraform-ovh-publiccloud-cfssl/modules/install-cfssl/install-cfssl --version {{user `cfssl_version`}}"
    ],
    "pause_before": "30s"
  }]
}
```

You should replace `<MODULE_VERSION>` in the code above with the version of this module that you want to use (see the [Releases Page](../../releases) for all available versions). That's because for production usage, you should always use a fixed, known version of this Module, downloaded from the official Git repo. On the other hand, when you're just experimenting with the Module, it's OK to use a local checkout of the Module, uploaded from your own computer.
