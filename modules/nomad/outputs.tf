output "server_address" {
  value = [
    aws_instance.nomad_ec2[0].public_dns,
    aws_instance.nomad_ec2[1].public_dns,
    aws_instance.nomad_ec2[2].public_dns
  ]
}

output "instances_ids" {
  value = [
    aws_instance.nomad_ec2[0].id,
    aws_instance.nomad_ec2[1].id,
    aws_instance.nomad_ec2[2].id
  ]
}

