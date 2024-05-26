resource "aws_subnet" "default" {
  cidr_block        = var.subnet.cidr_block
  availability_zone = var.subnet.availability_zone
  vpc_id            = aws_vpc.default.id

  # If true, a public IP address is automatically assigned to the instance
  map_public_ip_on_launch = var.subnet.map_public_ip_on_launch

  tags = {
    Name = var.subnet.name
  }
}
