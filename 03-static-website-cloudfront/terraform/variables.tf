# -----------------------------------------------------------------------------
# Root Variables — Static Website Hosting
# Declares input variables for S3 static website with CloudFront CDN.
# Values provided per environment via terraform.tfvars files.
# -----------------------------------------------------------------------------


variable "aws_region" {
  type        = string
  description = "AWS region for S3 bucket and CloudFront distribution"
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev, staging, prod)"
}