###############################################################################
# General
###############################################################################

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-southeast-3" # Jakarta
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "ec2-nlb-tls"
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}

###############################################################################
# Network (data lookups)
###############################################################################

variable "vpc_name" {
  description = "Name tag value of the existing VPC"
  type        = string
}

variable "private_subnet_name" {
  description = "Name tag value of the existing private subnet (for EC2)"
  type        = string
}

variable "public_subnet_names" {
  description = "Name tag values of existing public subnets (for NLB, recommend 2+ for HA)"
  type        = list(string)
}

###############################################################################
# EC2
###############################################################################

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_pair_name" {
  description = "Name of existing EC2 key pair for SSH access"
  type        = string
}

###############################################################################
# TLS / ACM
###############################################################################

variable "existing_acm_arn" {
  description = "ARN of an existing ACM certificate. If set, the new ACM request is skipped."
  type        = string
  default     = ""
}

variable "create_acm_certificate" {
  description = "Whether to request a new ACM certificate (email validation)"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "Domain name for the new ACM certificate (required if create_acm_certificate = true)"
  type        = string
  default     = ""
}

variable "subject_alternative_names" {
  description = "Additional SANs for the new ACM certificate"
  type        = list(string)
  default     = []
}

###############################################################################
# NLB
###############################################################################

variable "nlb_listener_port" {
  description = "Port the NLB TLS listener binds to"
  type        = number
  default     = 9001
}
