###############################################################################
# Security Group — EC2 Nginx instance
###############################################################################

module "ec2_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1"

  name        = "${var.project_name}-ec2-sg"
  description = "Allow HTTP from NLB and optional SSH"
  vpc_id      = data.aws_vpc.this.id

  # Ingress: allow HTTP (port 80) from the VPC CIDR (NLB forwards within VPC)
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP from VPC (NLB health checks and traffic)"
      cidr_blocks = data.aws_vpc.this.cidr_block
    },
  ]

  # Egress: allow all outbound (needed for yum/dnf to install nginx)
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all outbound"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = var.tags
}
