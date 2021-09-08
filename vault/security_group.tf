resource "aws_security_group" "vault_sg" {
    name        = "vault_sg"
    description = "create vpc group for ec2 instance"

  
    ingress {
        from_port   = var.http_port
        to_port     = var.http_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = var.ssh_port
        to_port     = var.ssh_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8200
        to_port = 8200
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }


    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}