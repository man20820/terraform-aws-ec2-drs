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

data "aws_subnets" "public" {
  filter {
    name   = "tag:Name"
    values = var.public_subnet_names
  }
}

###############################################################################
# Latest Amazon Linux 2023 AMI
###############################################################################

data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}
