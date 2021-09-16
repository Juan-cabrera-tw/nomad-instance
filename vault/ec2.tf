resource "aws_instance" "vault_server" {

  ami = "ami-9686a4f3"
  instance_type = "t2.micro"
  security_groups = ["vault_sg"]
  # key_name = aws_key_pair.vault_key.key_name
  key_name = "vault_key"

  tags = {
   Name = "Vault"
  }
  //SET_PRIVATE_KEY field 
  provisioner "local-exec" {
     command = "echo [vault-server] '\n' ${aws_instance.vault_server.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=./${var.PRIVATE_KEY_PATH} > ./ansible/hosts"
   }
}