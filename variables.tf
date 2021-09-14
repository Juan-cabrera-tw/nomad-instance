variable "AWS_REGION" {
  default = "us-east-2"
}

variable "PRIVATE_KEY_PATH" {
  default = "./id_rsa.pem"
}

variable "PUBLIC_KEY_PATH" {
  default = "./id_rsa.pub"
}

variable "platform" {
  default     = "ubuntu"
  description = "The OS Platform"
}

variable "my_system" {
  default = "191.99.141.224/32"
}

variable "http_port" {
  default = 80
}

variable "ssh_port" {
  default = 22
}

