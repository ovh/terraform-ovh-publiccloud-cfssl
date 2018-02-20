output "tf_test" {
  description = "Command to test if example ran well"
  value = "curl --silent --fail -k -XPOST -d '{\"label\":\"primary\"}' ${module.cfssl.public_endpoint}/api/v1/cfssl/info | jq -r '.result.certificate'"
}

output "helper" {
  description = "human friendly helper"
  value = <<DESC
You can get the self generated CA by typing:

$ curl -k -XPOST -d '{"label":"primary"}' ${module.cfssl.public_endpoint}/api/v1/cfssl/info

Enjoy!
DESC
}
