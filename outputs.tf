###############################################################################
# Outputs
###############################################################################

output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = module.ec2.id
}

output "ec2_private_ip" {
  description = "Private IP of the EC2 instance"
  value       = module.ec2.private_ip
}
