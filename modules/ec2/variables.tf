variable "ami_owners" {
  description = "AMI owners"
  type        = list(string)
  default     = []
}

variable "ami_name_values" {
  description = "AMI name to be filtered"
  type        = list(string)
  default     = []
}

variable "instance_security_group_id" {
  description = "ID of the security group to be assigned to the EC2 instance"
  type        = string
  default     = ""
}

variable "instance_vpc_subnet_id" {
  description = "ID of the subnet to be assigned to the EC2 instance"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type to be created"
  type        = string
  default     = ""
}

variable "instance_name" {
  description = "Instance name to be set as tag"
  type        = string
  default     = ""
}

variable "private_ip" {
  description = "Private IP of EC2 instance"
  type        = string
  default     = null
}

variable "aws_key_pair_name" {
  description = "Name of the key pair to store the public key for SSH"
  type        = string
  default     = ""
}

variable "ssh_pubkey" {
  description = "File path of the public key used to SSH to EC2"
  type        = string
  default     = ""
}
