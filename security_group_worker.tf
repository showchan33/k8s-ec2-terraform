resource "aws_security_group" "worker" {
  name   = var.security_group.name_worker
  vpc_id = aws_vpc.default.id

  # for SSH access
  ingress {
    from_port   = var.security_group.port_ssh
    to_port     = var.security_group.port_ssh
    protocol    = "tcp"
    cidr_blocks = var.security_group.cidr_blocks_for_ssh
  }

  # for kubelet
  ingress {
    from_port   = var.security_group.port_kubelet
    to_port     = var.security_group.port_kubelet
    protocol    = "tcp"
    cidr_blocks = [var.subnet.cidr_block]
  }

  # for nodeport
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = [var.subnet.cidr_block]
  }

  dynamic "ingress" {
    for_each = var.ingress_rules_k8s_additional
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = [var.subnet.cidr_block]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
