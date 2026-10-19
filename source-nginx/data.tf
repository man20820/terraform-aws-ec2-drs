###############################################################################
# Data sources — look up existing VPC and subnets by Name tag
###############################################################################

data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "private" {
  filter {
    name   = "tag:Name"
    values = [var.private_subnet_name]
  }
}

data "aws_subnet" "public" {
  filter {
    name   = "tag:Name"
    values = [var.public_subnet_name]
  }
}

###############################################################################
# Latest Ubuntu 24.04 LTS (Noble) AMI — published by Canonical via SSM
#
# AL2023's "latest" currently boots a 6.18 kernel, which is ABOVE the AWS DRS
# supported kernel ceiling (6.14) and has no matching kernel-devel package, so
# the DRS replication driver cannot be built. Ubuntu 24.04 (kernel 6.8) is a
# DRS-supported OS and provides matching linux-headers from its own repos, so
# the agent's kernel module compiles cleanly.
###############################################################################

data "aws_ssm_parameter" "ubuntu2404" {
  name = "/aws/service/canonical/ubuntu/server/noble/stable/current/amd64/hvm/ebs-gp3/ami-id"
}
