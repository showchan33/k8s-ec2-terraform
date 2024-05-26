
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = var.ami_name_values
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = var.ami_owners
}

resource "aws_instance" "default" {
  ami                    = data.aws_ami.ubuntu.image_id
  instance_type          = var.instance_type
  subnet_id              = var.instance_vpc_subnet_id
  vpc_security_group_ids = [var.instance_security_group_id]
  key_name               = aws_key_pair.ssh_key.id
  private_ip             = var.private_ip

  tags = {
    Name = var.instance_name
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name   = var.aws_key_pair_name
  public_key = file(var.ssh_pubkey)
}
