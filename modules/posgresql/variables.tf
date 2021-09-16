variable "ACCESS_KEY" {}
variable "SECRET_KEY" {}
variable "region" {
  default = "us-east-2"
}
variable "bucket" {
  default = "bucket"
}
variable "ami" {
  # default = "ami-00399ec92321828f5" #ubuntu
  #   default = "ami-000102dbe3fd021c3" #centos
  default = "ami-00dfe2c7ce89a450b" #amazon linux
}
variable "instance_type" {
  default = "t2.micro"
}

variable "workspace" {
  default = "user"
}
variable "password" {
  default = "admin"
}

variable "subnets" {
  type        = map(string)
  description = "map of subnets to deploy your infrastructure in, must have as many keys as your server count (default 3), -var 'subnets={\"0\"=\"subnet-12345\",\"1\"=\"subnets-23456\"}' "
}
variable "private_ip" {
  default = "172.31.48.11"
}

variable "vpc_security_group_ids" {
  description = "ID of the VPC to use - in case your account doesn't have default VPC"
}

variable "key_path" {
  description = "Path to the private key specified by key_name."
}

variable "key_name" {
  description = "SSH key name in your AWS account for AWS instances."
}
