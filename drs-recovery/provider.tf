terraform {
  backend "s3" {
    bucket = "man-jakarta-tfstate"
    # SEPARATE state key -> this project's state is isolated from the source
    # nginx project (ec2-nginx/terraform.tfstate). This is what lets you manage
    # the two instances independently with no lifecycle collision.
    key    = "drs-recovery/terraform.tfstate"
    region = "ap-southeast-3"
  }
}

provider "aws" {
  region = var.aws_region
}
