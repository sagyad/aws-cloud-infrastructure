# -----------------------------------------------------------------------------
# Local Values — Static Website Hosting
# Computes project-wide naming prefix and common resource tags.
# Centralises values used across all resources to ensure consistency.
# -----------------------------------------------------------------------------


locals {
  project_name = "03-static-website-cloudfront"
  name_prefix  = "${local.project_name} - ${var.environment}"
  s3_origin_id = "${local.name_prefix}-s3-origin"

  common_tags = {
    Project     = local.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
