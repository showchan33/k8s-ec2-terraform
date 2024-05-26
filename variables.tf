variable "var_provider" {
  default = {
    region     = "ap-northeast-1"
    access_key = ""
    secret_key = ""
  }
}

variable "vpc" {
  default = {
    name       = "vpc_k8s"
    cidr_block = "10.0.0.0/27"
  }
}

variable "subnet" {
  default = {
    name                    = "subnet_k8s"
    cidr_block              = "10.0.0.0/27"
    availability_zone       = null
    map_public_ip_on_launch = true
  }
}

variable "ec2_control_plane" {
  default = {
    ami_owners        = []
    ami_name_values   = []
    instance_type     = "t3a.small"
    instance_name     = "kubernetes_setup_control_plane"
    private_ip        = null
    ssh_pubkey        = "./files/sshkey.pub"
    aws_key_pair_name = "ssh_key_control_plane"
  }
}

variable "ec2_workers" {
  default = [
    {
      ami_owners        = []
      ami_name_values   = []
      instance_type     = "t3.micro"
      instance_name     = "kubernetes_setup_worker1"
      private_ip        = null
      ssh_pubkey        = "./files/sshkey.pub"
      aws_key_pair_name = "ssh_key_worker1"
    },
    {
      ami_owners        = []
      ami_name_values   = []
      instance_type     = "t3.micro"
      instance_name     = "kubernetes_setup_worker2"
      private_ip        = null
      ssh_pubkey        = "./files/sshkey.pub"
      aws_key_pair_name = "ssh_key_worker2"
    }
  ]
}

variable "security_group" {
  default = {
    name_control_plane  = "sg_k8s_control_plan"
    name_worker         = "sg_k8s_worker"
    port_ssh            = 22
    port_apiserver      = 6443
    port_kubelet        = 10250
    cidr_blocks_for_ssh = []
  }
}

variable "ingress_rules_k8s_additional" {
  type = map(object({
    from_port = number
    to_port   = number
    protocol  = string
  }))
  default = {}
}

variable "internet_gateway" {
  default = {
    name = "internet_gateway_k8s"
  }
}

variable "route_table" {
  default = {
    name = "route_table_k8s"
  }
}
