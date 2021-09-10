variable "platform" {
  default     = "ubuntu"
  description = "The OS Platform"
}

variable "user" {
  default = "ubuntu"
}

variable "ami" {
  description = "AWS AMI Id, if you change, make sure it is compatible with instance type, not all AMIs allow all instance types "
  default     = "ami-9686a4f3"
}

variable "service_nomad_conf" {
  default = "debian_nomad.service"
}

variable "service_nomad_conf_dest" {
  default = "nomad.service"
}

variable "service_consul_conf" {
  default = "debian_consul.service"
}

variable "service_consul_conf_dest" {
  default = "consul.service"
}

variable "key_name" {
  description = "SSH key name in your AWS account for AWS instances."
}

variable "key_path" {
  description = "Path to the private key specified by key_name."
}

variable "region" {
  description = "The region of AWS, for AMI lookups."
}

variable "servers" {
  default     = "1"
  description = "The number of nomad servers to launch."
}

variable "clients" {
  default     = "2"
  description = "The number of nomad servers to launch."
}

variable "instance_type" {
  default     = "t2.micro"
  description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
}

variable "tagName" {
  default     = "nomad"
  description = "Name tag for the servers"
}

variable "subnets" {
  type        = map(string)
  description = "map of subnets to deploy your infrastructure in, must have as many keys as your server count (default 3), -var 'subnets={\"0\"=\"subnet-12345\",\"1\"=\"subnets-23456\"}' "
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC to use - in case your account doesn't have default VPC"
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

