# -----------------------------------------------------------------------------
# Local Values
# Computed values reused across resources — naming prefix and common tags.
# Avoids repeating the same logic in every resource block.
# -----------------------------------------------------------------------------

locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

