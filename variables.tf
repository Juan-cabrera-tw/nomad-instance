variable "AWS_REGION" {
  default = "us-east-2"
}

variable "PRIVATE_KEY_PATH" {
  # default = "./id_rsa.pem"
  # default = {TF_VAR_idrsapem}
}

variable "PUBLIC_KEY_PATH" {
  # default = "./id_rsa.pub"
  # kdefault = {TF_VAR_idrsapub}
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

