###############################################################################
# Network Load Balancer — internet-facing, TLS listener on port 9001
###############################################################################

module "nlb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name               = "${var.project_name}-nlb"
  load_balancer_type = "network"
  internal           = false

  vpc_id  = data.aws_vpc.this.id
  subnets = data.aws_subnets.public.ids

  # For example/dev — set to true in production
  enable_deletion_protection = false

  # Security group for NLB
  security_group_ingress_rules = {
    tls_ingress_9001 = {
      from_port   = var.nlb_listener_port
      to_port     = var.nlb_listener_port
      ip_protocol = "tcp"
      description = "TLS traffic from internet (port 9001)"
      cidr_ipv4   = "0.0.0.0/0"
    }
    tls_ingress_9002 = {
      from_port   = 9002
      to_port     = 9002
      ip_protocol = "tcp"
      description = "TLS traffic from internet (port 9002)"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  # TLS Listener on port 9001 → forwards to target group (EC2 nginx port 80)
  listeners = {
    tls = {
      port            = var.nlb_listener_port
      protocol        = "TLS"
      certificate_arn = local.acm_certificate_arn
      ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"

      forward = {
        target_group_key = "nginx"
      }
    }
  }

  # Target group — TCP port 80 to EC2 instance
  target_groups = {
    nginx = {
      name_prefix = "nginx-"
      protocol    = "TCP"
      port        = 80
      target_type = "instance"
      target_id   = module.ec2.id

      health_check = {
        enabled             = true
        protocol            = "HTTP"
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        interval            = 30
      }
    }
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-nlb"
  })
}

###############################################################################
# Additional TLS Listener on port 9002 (native resource, same target group)
###############################################################################

resource "aws_lb_listener" "tls_9002" {
  load_balancer_arn = module.nlb.arn
  port              = 9002
  protocol          = "TLS"
  certificate_arn   = local.acm_certificate_arn
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  default_action {
    type             = "forward"
    target_group_arn = module.nlb.target_groups["nginx"].arn
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-nlb-listener-9002"
  })
}
