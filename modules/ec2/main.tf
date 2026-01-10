
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

  dynamic "root_block_device" {
    for_each = var.root_block_device_config != null ? [var.root_block_device_config] : []

    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      tags                  = contains(keys(root_block_device.value), "tags") ? root_block_device.value.tags : {}
      throughput            = lookup(root_block_device.value, "throughput", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
    }
  }

  tags = {
    Name = var.instance_name
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name   = var.aws_key_pair_name
  public_key = file(var.ssh_pubkey)
}

resource "aws_ebs_volume" "default" {
  count                = var.ebs_configs != null ? length(var.ebs_configs) : 0
  availability_zone    = aws_instance.default.availability_zone
  encrypted            = lookup(var.ebs_configs[count.index], "encrypted", true)
  final_snapshot       = lookup(var.ebs_configs[count.index], "final_snapshot", false)
  iops                 = lookup(var.ebs_configs[count.index], "iops", null)
  multi_attach_enabled = lookup(var.ebs_configs[count.index], "multi_attach_enabled", false)
  size                 = lookup(var.ebs_configs[count.index], "size", 10)
  type                 = lookup(var.ebs_configs[count.index], "type", "gp3")
  tags                 = lookup(var.ebs_configs[count.index], "tags", null)
  throughput           = lookup(var.ebs_configs[count.index], "throughput", null)
  # snapshot_id          = lookup(var.ebs_configs[count.index], "snapshot_id", null)
  # outpost_arn          = lookup(var.ebs_configs[count.index], "outpost_arn", null)
  # kms_key_id           = lookup(var.ebs_configs[count.index], "kms_key_id", null)
}

resource "aws_volume_attachment" "default" {
  for_each = {
    for idx, volume in aws_ebs_volume.default : idx => volume
  }
  device_name = format("/dev/sd%s", substr("fghijklmnopqrstuvwxyz", each.key, 1))
  volume_id   = each.value.id
  instance_id = aws_instance.default.id
}

resource "aws_eip" "default" {
  count  = var.create_eip && (var.eip_allocation_id == null || var.eip_allocation_id == "") ? 1 : 0
  domain = "vpc"
  tags   = merge({ Name = "${var.instance_name}-eip" }, var.eip_tags)
}

resource "aws_eip_association" "default" {
  count         = var.create_eip || (var.eip_allocation_id != null && var.eip_allocation_id != "") ? 1 : 0
  instance_id   = aws_instance.default.id
  allocation_id = coalesce(var.eip_allocation_id, try(aws_eip.default[0].id, null))
}
