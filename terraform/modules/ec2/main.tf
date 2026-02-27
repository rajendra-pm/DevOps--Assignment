resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated" {
  key_name   = "terraform-ec2-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.ec2_key.private_key_pem
  filename = "terraform-ec2-key.pem"
  file_permission = "0400"
}



resource "aws_instance" "main" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  subnet_id            = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  iam_instance_profile = var.instance_profile
  key_name             = var.key_name

  tags = {
    Name = "Terraform-EC2"
  }
}
