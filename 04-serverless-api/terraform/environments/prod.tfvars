# -----------------------------------------------------------------------------
# Production Environment Configuration
# Project: 04-serverless-api
#
# Purpose: Live production environment serving real API traffic.
# Usage:   terraform plan -var-file=environments/prod.tfvars
#
# Note: Higher memory and timeout for production workloads.
#       Requires manual approval in GitHub Actions before deployment.
#       All changes must go through staging first.
# -----------------------------------------------------------------------------

# --- General ---
project_name = "04-serverless-api"
aws_region   = "eu-west-2"
environment  = "prod"

# --- API Gateway ---
api_stage_name  = "prod"
api_description = "Serverless REST API with Lambda + DynamoDB"

# --- Lambda ---
lambda_runtime     = "python3.12"
lambda_memory_size = 256
lambda_timeout     = 10
