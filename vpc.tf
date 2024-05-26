resource "aws_vpc" "default" {
  cidr_block           = var.vpc.cidr_block
  enable_dns_support   = true # DNS解決を有効化
  enable_dns_hostnames = true # DNSホスト名を有効化

  tags = {
    Name = var.vpc.name
  }
}
