output "public_ip_control_plane" {
  description = "Public IP address assigned to the host by EC2 for Control Plane"
  value       = module.ec2_control_plane.public_ip
}

output "public_ip_worker" {
  description = "Public IP address assigned to the host by EC2 for Worker Node"
  value       = { for k, v in module.ec2_worker : k => v.public_ip }
}
