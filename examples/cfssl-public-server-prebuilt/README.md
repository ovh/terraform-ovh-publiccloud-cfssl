Cfssl public server example
==========

Configuration in this directory creates set of openstack resources which will spawn a Cfssl server with a public internet IPv4.

It will spawn a public openstack instance based on a preconfigured Centos 7 with Cfssl installed.

Usage
=====

To run this example you need to execute:

```bash
$ terraform init
$ terraform apply -var os_region_name=BHS3
...
$ terraform destroy -var os_region_name=BHS3
```

Note that this example may create resources which can cost money (Openstack Instance, for example). Run `terraform destroy` when you don't need these resources.
