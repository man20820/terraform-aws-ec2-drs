terraform {
  backend "s3" {
    bucket = "man-jakarta-tfstate" # <-- set your S3 bucket name here
    key    = "ec2-nginx/terraform.tfstate"
    region = "ap-southeast-3"
  }
}

provider "aws" {
  region = var.aws_region
}
