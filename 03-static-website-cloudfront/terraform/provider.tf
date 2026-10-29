# -----------------------------------------------------------------------------
# Provider Configuration — Static Website Hosting
# Configures AWS provider and Terraform backend for S3-hosted static website
# with CloudFront CDN distribution.
# State stored in S3 with environment-isolated key paths.
# -----------------------------------------------------------------------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket       = "sy-terraform-state-bk-eu-west-2"
    key          = "cloud-infra/03-static-website-cloudfront/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
    encrypt      = true
  }
}