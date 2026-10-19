###############################################################################
# Outputs
###############################################################################

output "recovery_instance_id" {
  description = "The DRS recovery instance id now under Terraform management"
  value       = aws_instance.recovery.id
}

output "recovery_private_ip" {
  description = "Private IP of the recovery instance"
  value       = aws_instance.recovery.private_ip
}

output "recovery_iam_instance_profile" {
  description = "IAM instance profile attached to the recovery instance"
  value       = aws_instance.recovery.iam_instance_profile
}
