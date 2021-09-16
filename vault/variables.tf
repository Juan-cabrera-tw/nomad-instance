variable "AWS_REGION" {
  default = "us-east-2"
}

variable "PRIVATE_KEY_PATH" {
  default = "./vault_key.pem"
}

# variable "PUBLIC_KEY_PATH" {
#   default = "./id_rsa.pub"
# }

variable "http_port" {
  default = 80
}

variable "ssh_port" {
  default = 22
}
