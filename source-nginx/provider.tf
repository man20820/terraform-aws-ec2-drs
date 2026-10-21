terraform {
  backend "s3" {
    bucket = "man-jakarta-tfstate" # <-- set your S3 bucket name here
    key    = "ec2-nginx/terraform.tfstate"
    region = "ap-southeast-3"
  }
}

provider "aws" {
  region = var.aws_region

  # AWS DRS applies and manages its own tags on the source instance and its
  # replicated volumes (e.g. AWSElasticDisasterRecoveryManaged,
  # AWSElasticDisasterRecoverySourceServerID, and the volume Name it rewrites).
  # Tell Terraform to never manage tags with these keys/prefixes so it stops
  # trying to strip DRS-owned tags on every plan.
  ignore_tags {
    keys         = ["AWSDRS"]
    key_prefixes = ["AWSElasticDisasterRecovery"]
  }
}
