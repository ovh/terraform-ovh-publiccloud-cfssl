resource "null_resource" "post_install" {
  count = "${var.count}"

  triggers {
    trigger = "${element(var.triggers, count.index)}"
  }

  connection {
    host                = "${element(var.ipv4_addrs, count.index)}"
    user                = "${var.ssh_user}"
    bastion_host        = "${var.ssh_bastion_host}"
    bastion_user        = "${var.ssh_bastion_user}"
  }

  provisioner "remote-exec" {
    inline = [ "mkdir -p /tmp/install-cfssl" ]
  }

  provisioner "file" {
    source      = "${path.module}/"
    destination = "/tmp/install-cfssl"
  }

  provisioner "remote-exec" {
    inline = [
      "/bin/bash /tmp/install-cfssl/system-upgrade.sh",
      "/bin/bash /tmp/install-cfssl/install-cfssl --version ${var.cfssl_version} --sha256sum ${var.cfssl_sha256sum}",
      "echo start cfssl; sudo systemctl restart cfssl.service || true"
    ]
  }
}
