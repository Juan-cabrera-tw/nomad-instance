module "shared-state" {
  source               = "./modules/shared-state"
  s3_bucket_name       = "tf-squad-state"
  dynamo_db_table_name = "terraform-lock"
}

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "tf-squad-state"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-lock"
  }
}

module "posgresql" {
  source   = "./modules/posgresql"
  key_name = aws_key_pair.key.key_name
  # key_path               = file(var.PRIVATE_KEY)
  key_path               = var.PRIVATE_KEY
  region                 = var.AWS_REGION
  vpc_security_group_ids = ["${aws_security_group.lab_squad_sg.id}"]
  ACCESS_KEY             = ""
  SECRET_KEY             = ""
  vault_private_addr     = var.VAULT_PRIVATE_ADDR
  subnets = {
    "0" = aws_default_subnet.default_az1.id
    "1" = aws_default_subnet.default_az2.id
    "2" = aws_default_subnet.default_az3.id
  }
}

module "nomad" {
  source   = "./modules/nomad"
  key_name = aws_key_pair.key.key_name
  key_path = var.PRIVATE_KEY
  # key_path               = file(var.PRIVATE_KEY)
  region                 = var.AWS_REGION
  vpc_id                 = aws_default_vpc.default.id
  vpc_security_group_ids = ["${aws_security_group.lab_squad_sg.id}"]
  vault_addr             = var.VAULT_ADDR
  vault_private_addr     = var.VAULT_PRIVATE_ADDR
  vault_token            = var.VAULT_TOKEN

  subnets = {
    "0" = aws_default_subnet.default_az1.id
    "1" = aws_default_subnet.default_az2.id
    "2" = aws_default_subnet.default_az3.id
  }
  depends_on = [module.posgresql]
}

output "nomad-output" {
  value = module.nomad.server_address
}
