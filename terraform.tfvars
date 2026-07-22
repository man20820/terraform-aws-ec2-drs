# ==============================================================================
# Fill in your environment-specific values below
# ==============================================================================

# Network - existing resource Name tags
vpc_name            = "MAN-VPC"          # e.g. "production-vpc"
private_subnet_name = "MAN-VPC-private-*"          # e.g. "private-subnet-a"
public_subnet_names = ["MAN-VPC-public-*"]        # e.g. ["public-subnet-a", "public-subnet-b"]

# EC2
key_pair_name = "swo_keypair"                # e.g. "my-keypair"

# TLS / ACM — Option A: use existing certificate
existing_acm_arn = "arn:aws:acm:ap-southeast-3:108782069919:certificate/f4e3210a-716c-4359-996e-b2fbac8b45d5"                      # e.g. "arn:aws:acm:ap-southeast-3:123456789012:certificate/abc-123"

# TLS / ACM — Option B: request new certificate (email validation)
# create_acm_certificate    = true
# domain_name               = "example.com"
# subject_alternative_names = ["*.example.com"]

# Tags (optional)
# tags = {
#   Environment = "dev"
#   Team        = "platform"
# }
