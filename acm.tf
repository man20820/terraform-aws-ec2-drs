###############################################################################
# ACM Certificate (optional — email validation, no Route 53 required)
###############################################################################

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 5.0"

  create_certificate = var.create_acm_certificate

  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names

  validation_method      = "EMAIL"
  create_route53_records = false
  validate_certificate   = false
  wait_for_validation    = false

  tags = merge(var.tags, {
    Name = "${var.project_name}-acm"
  })
}

###############################################################################
# Resolve which certificate ARN to use for the NLB listener
###############################################################################

locals {
  acm_certificate_arn = var.create_acm_certificate ? module.acm.acm_certificate_arn : var.existing_acm_arn
}
