# -----------------------------------------------------------------------------
# Provider Configuration
# Defines the AWS provider version and remote state backend.
# State is stored in S3 to enable team collaboration and state locking.
# -----------------------------------------------------------------------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  # Remote state — ensures Terraform state is shared, versioned, and recoverable
  backend "s3" {
    bucket       = "sy-terraform-state-bk-eu-west-2"
    key          = "cloud-infra/01-high-availability/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
    encrypt      = true
  }

}
# AWS provider — region is passed via variable for multi-environment support
provider "aws" {
  region = "eu-west-2"
}