output "tf_test" {
  description = "Command to test if example ran well"
  value = "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ProxyCommand='ssh -o StrictHostKeyChecking=no core@${module.network.bastion_public_ip} ncat %h %p' core@${module.cfssl.private_ipv4_addr} \"curl --silent --fail -k -XPOST -d '{\\\"label\\\":\\\"primary\\\"}' ${module.cfssl.endpoint}/api/v1/cfssl/info | jq -r '.result.certificate'\""

}

output "helper" {
  description = "human friendly helper"
  value = <<DESC
You can get the self generated CA by typing:

$ ssh -J core@${module.network.bastion_public_ip} core@${module.cfssl.private_ipv4_addr} "curl --silent --fail -k -XPOST -d '{\"label\":\"primary\"}' ${module.cfssl.endpoint}/api/v1/cfssl/info | jq -r '.result.certificate'"

Enjoy!
DESC
}
