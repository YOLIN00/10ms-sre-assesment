resource "tls_private_key" "generate_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "terraform-ec2-key"
  public_key = tls_private_key.generate_key.public_key_openssh
}


resource "aws_secretsmanager_secret" "ec2_private_key" {
  name = "ec2-private-key"
}

resource "aws_secretsmanager_secret_version" "ec2_private_key_version" {
  secret_id     = aws_secretsmanager_secret.ec2_private_key.id
  secret_string = tls_private_key.generate_key.private_key_pem
}

