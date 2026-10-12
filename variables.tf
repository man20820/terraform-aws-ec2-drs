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

variable "public_subnet_name" {
  description = "Name tag value of the existing public subnet (for EC2 with public IP)"
  type        = string
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

