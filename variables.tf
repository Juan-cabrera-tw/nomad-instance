variable "AWS_REGION" {
  default = "us-east-2"
}

variable "PRIVATE_KEY" {
  default = "./id_rsa.pem"
}

variable "PUBLIC_KEY" {
  default = "./id_rsa.pub"
}

variable "platform" {
  default     = "ubuntu"
  description = "The OS Platform"
}

variable "my_system" {
  default = "191.99.141.142/32"
}

variable "http_port" {
  default = 80
}

variable "ssh_port" {
  default = 22
}
variable "ACTIONS_SG_ID" {
}
variable "VAULT_ADDR" {
}
variable "VAULT_TOKEN" {
}

variable "IP_GITHUB" {
  # default = "191.99.141.132/32"
}

variable "VAULT_PRIVATE_ADDR" {

}
