# -----------------------------------------------------------------------------
# Local Values
# Computed values reused across resources — naming prefix and common tags.
# Avoids repeating the same logic in every resource block.
# -----------------------------------------------------------------------------


locals {
  # --- Naming Prefix ---
  project_name = "02-eks-k8s"
  name_prefix  = "${local.project_name}-${var.environment}"

  common_tags = {
    Project     = local.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}