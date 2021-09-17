resource "aws_instance" "nomad_ec2" {
  # ami             = var.ami["${var.region}-${var.platform}"]
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  count                  = var.servers + var.clients
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id       = var.subnets[count.index % var.servers]
  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.user
    private_key = var.key_path
    # private_key = file(var.key_path)
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

  provisioner "file" {
    source      = var.servers > count.index ? "${path.module}/shared/scripts/nomad-server.conf" : "${path.module}/shared/scripts/nomad-client.conf"
    destination = "/tmp/nomad.conf"
  }

  provisioner "file" {
    source      = "${path.module}/shared/scripts/docker-auth.json"
    destination = "/tmp/docker-auth.json"
  }

  provisioner "file" {
    source      = "${path.module}/shared/scripts/fabio.nomad"
    destination = "/tmp/fabio.nomad"
  }

  provisioner "remote-exec" {
    inline = [
      var.servers > count.index ? "echo ${var.servers} > /tmp/nomad-server-count" : "echo ${var.clients} > /tmp/nomad-client-count",
      "echo ${aws_instance.nomad_ec2[0].private_ip} > /tmp/nomad-server-addr",
    ]
  }

  provisioner "remote-exec" {
    scripts = [
      "${path.module}/shared/scripts/install.sh",
      "${path.module}/shared/scripts/service.sh",
      "${path.module}/shared/scripts/run.sh"
    ]
  }
}
