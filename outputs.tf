###############################################################################
# Outputs
###############################################################################

output "nlb_dns_name" {
  description = "DNS name of the Network Load Balancer"
  value       = module.nlb.dns_name
}

output "nlb_arn" {
  description = "ARN of the Network Load Balancer"
  value       = module.nlb.arn
}

output "nlb_endpoint" {
  description = "Full endpoint to access the service (TLS on port 9001)"
  value       = "https://${module.nlb.dns_name}:${var.nlb_listener_port}"
}

output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = module.ec2.id
}

output "ec2_private_ip" {
  description = "Private IP of the EC2 instance"
  value       = module.ec2.private_ip
}

output "acm_certificate_arn" {
  description = "ACM certificate ARN used by the NLB listener"
  value       = local.acm_certificate_arn
}
