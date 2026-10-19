###############################################################################
# Data sources — look up the existing VPC (for the shared SG vpc_id)
###############################################################################

data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}
