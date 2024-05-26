module "ec2_control_plane" {
  source                     = "./modules/ec2"
  ami_owners                 = var.ec2_control_plane.ami_owners
  ami_name_values            = var.ec2_control_plane.ami_name_values
  instance_security_group_id = aws_security_group.control_plane.id
  instance_vpc_subnet_id     = aws_subnet.default.id
  instance_type              = var.ec2_control_plane.instance_type
  instance_name              = var.ec2_control_plane.instance_name
  private_ip                 = var.ec2_control_plane.private_ip
  ssh_pubkey                 = var.ec2_control_plane.ssh_pubkey
  aws_key_pair_name          = var.ec2_control_plane.aws_key_pair_name
}

module "ec2_worker" {
  source                     = "./modules/ec2"
  for_each                   = { for ec2_worker in var.ec2_workers : ec2_worker.instance_name => ec2_worker }
  ami_owners                 = each.value.ami_owners
  ami_name_values            = each.value.ami_name_values
  instance_security_group_id = aws_security_group.worker.id
  instance_vpc_subnet_id     = aws_subnet.default.id
  instance_type              = each.value.instance_type
  instance_name              = each.value.instance_name
  private_ip                 = each.value.private_ip
  ssh_pubkey                 = each.value.ssh_pubkey
  aws_key_pair_name          = each.value.aws_key_pair_name
}
