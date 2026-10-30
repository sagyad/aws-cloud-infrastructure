# -----------------------------------------------------------------------------
# Local Values
# Project: 04-serverless-api
#
# Purpose: Computed values and naming conventions used across all resources.
#          - name_prefix: consistent resource naming ({project}-{env})
#          - common_tags: applied to every resource for cost tracking and governance
#
# Note: No hardcoded values — all inputs come from variables.tf
# -----------------------------------------------------------------------------


locals {
    name_prefix = "${var.project_name}-${var.environment}"

    common_tags = {
        Project = var.project_name
        Environment = var.environment
        ManagedBy = "Terraform"
    }
}