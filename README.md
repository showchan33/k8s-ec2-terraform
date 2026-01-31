# About k8s-ec2-terraform
This tool creates an AWS EC2 instance and associated resources for a Kubernetes cluster. AWS resources are created using Terraform.<br>
To complete the creation of your Kubernetes cluster, please use [k8s-setup](https://github.com/showchan33/k8s-setup/tree/main) after creating an EC2 instance with this tool.

## Overview of AWS resources to be created

* EC2 instances
    * for Control Plane: one machine
    * for Worker Node: more than one machine
* Some resources for SSH access to EC2 instances
    * Internet Gateway to allow public IP SSH connections to each EC2 instance.

# Requirement

* Terraform must be installed.
    * Version confirmed to work is v1.8.4
* Must have an AWS account, an IAM user who can create each resource.

# Preparation

## Creating terraform.tfvars

Create ``terraform.tfvars`` with reference to ``terraform.tfvars.sample``.<br>
After this, all the configuration necessary to create the resource is done in ``terraform.tfvars``.

## Prepare public and private keys for SSH connection

Prepare the public and private keys for SSH connection to the EC2 instance.<br>
The following is an example command for creating a new key.

```
ssh-keygen -b 4096 -f ./files/sshkey
```

By default, the path to the public key file to be stored on the EC2 instance is ``. /files/sshkey.pub``. If necessary, rewrite the path to the public key specified in each key ``ssh_pubkey``.

## Specify the IP address of the SSH connection source

Rewrite the following value to the IP address of the client when connecting to EC2 via SSH.

```tfvars
security_group = {
  ...
  # Write down the IP address to SSH to the EC2 instance
  cidr_blocks_for_ssh = ["111.222.333.444/32"]
}
```

## Specify ingress rules to be added to the security group

Rewrite the rules for the ``ingress_rules_k8s_additional`` security group as needed.<br>
The following is an example of using Flannel as the CNI (Container Network Interface) for Kubernetes, but if you use a different CNI, please change the rules accordingly.

```tfvars
ingress_rules_k8s_additional = {
  # Example of using Flannel for CNI
  flannel = {
    from_port = 8472
    to_port   = 8472
    protocol  = "udp"
  }
}
```

## Other Configurations

Change each value in ``terraform.tfvars`` as needed.

# Creating EC2 instances

Execute the following commands in order to create the resource.

```
terraform init
terraform plan
terraform apply
```

# Confirmation of SSH connection to EC2 instance

Confirm that the created EC2 instance can be accessed via SSH.<br>
The public IP address of each EC2 instance can be found in the ``Outputs:`` at the end of the stdout of the ``terraform apply`` command.

```
ssh -i [private-key-filename] [username]@[public-ip-of-ec2]
```

# To create a Kubernetes cluster

Once the EC2 instance has been created, you can use [k8s-setup](https://github.com/showchan33/k8s-setup/tree/main) to create your Kubernetes cluster.

# Author
showchan33

# License
"k8s-ec2-terraform" is under [GPL license](https://www.gnu.org/licenses/licenses.en.html).
