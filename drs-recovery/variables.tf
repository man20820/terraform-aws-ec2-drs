###############################################################################
# General
###############################################################################

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-southeast-3" # Jakarta
}

variable "vpc_name" {
  description = "Name tag value of the existing VPC (used to resolve the shared SG)"
  type        = string
}

###############################################################################
# DRS recovery resource IDs (the instance DRS already launched)
#
# These are the LIVE ids pulled from AWS. If DRS relaunches the recovery
# instance (new recovery/failback job), it gets a NEW instance id and these
# values go stale -- update them, then re-run `terraform plan` / import.
###############################################################################

variable "recovery_instance_id" {
  description = "The DRS-launched recovery EC2 instance id"
  type        = string
  default     = "i-063a914ccd8d8f9b6"
}

variable "recovery_root_volume_id" {
  description = "Root EBS volume id of the recovery instance"
  type        = string
  default     = "vol-0bdd5a65217bb12aa"
}

variable "recovery_eni_id" {
  description = "Primary ENI id of the recovery instance"
  type        = string
  default     = "eni-0fb3ddcda4c4bcf47"
}

variable "recovery_security_group_id" {
  description = "Shared security group id attached to the recovery instance"
  type        = string
  default     = "sg-0c47035927e36f911"
}

variable "recovery_launch_template_id" {
  description = "DRS-managed launch template id for the recovery instance"
  type        = string
  default     = "lt-075c7f0ef61bd3ef2"
}

###############################################################################
# IAM — recovery instance role
#
# The recovery instance uses a pre-existing, shared instance-profile role
# (ec2-role-...). For AWS DRS failback ("Protect recovered instance" ->
# reverse replication) to initialize, this role must carry the DRS recovery
# and agent permissions. We attach the AWS-managed policies to the EXISTING
# role (attachment only -- Terraform does not own/mutate the role itself).
###############################################################################

variable "recovery_instance_profile_name" {
  description = "Name of the IAM instance profile attached to the DRS recovery instance (the real role name is resolved from this)"
  type        = string
  default     = "ec2-role-20250227042937428400000003"
}
