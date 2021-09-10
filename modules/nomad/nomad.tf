resource "aws_instance" "server" {
  # ami             = var.ami["${var.region}-${var.platform}"]
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  count                  = var.servers + var.clients
  vpc_security_group_ids = ["${aws_security_group.nomad.id}"]
  # subnet_id       = var.subnets[count.index % var.servers]
  subnet_id = "subnet-01df501ab30171646"

  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.user
    private_key = file(var.key_path)
  }

  tags = {
    Name      = "${var.tagName}-${count.index}"
    nomadRole = var.servers > count.index ? "server" : "client"
  }
  provisioner "file" {
    source      = "${path.module}/shared/scripts/${var.service_nomad_conf}"
    destination = "/tmp/${var.service_nomad_conf_dest}"
  }

  provisioner "file" {
    source      = "${path.module}/shared/scripts/${var.service_consul_conf}"
    destination = "/tmp/${var.service_consul_conf_dest}"
  }

  provisioner "remote-exec" {
    inline = [
      var.servers > count.index ? "echo ${var.servers} > /tmp/nomad-server-count" : "echo ${var.clients} > /tmp/nomad-client-count",
      "echo ${aws_instance.server[0].private_ip} > /tmp/nomad-server-addr",
    ]
  }

  provisioner "remote-exec" {
    scripts = [
      "${path.module}/shared/scripts/install.sh",
      "${path.module}/shared/scripts/service.sh"
    ]
  }
}