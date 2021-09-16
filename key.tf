resource "aws_key_pair" "key" {
  key_name   = "nomad_key"
  # public_key = file(var.PUBLIC_KEY_PATH)
  public_key = var.PUBLIC_KEY_PATH
}

