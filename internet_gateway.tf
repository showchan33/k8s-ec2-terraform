resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = var.internet_gateway.name
  }
}

resource "aws_route_table" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = var.route_table.name
  }
}

resource "aws_route" "default" {
  gateway_id             = aws_internet_gateway.default.id
  route_table_id         = aws_route_table.default.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "default" {
  subnet_id      = aws_subnet.default.id
  route_table_id = aws_route_table.default.id
}
