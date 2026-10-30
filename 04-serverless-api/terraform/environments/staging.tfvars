# -----------------------------------------------------------------------------
# Staging Environment Configuration
# Project: 04-serverless-api
#
# Purpose: Pre-production environment for integration testing and validation.
# Usage:   terraform plan -var-file=environments/staging.tfvars
#
# Note: Staging mirrors production settings to catch issues before release.
#       Requires manual approval in GitHub Actions before deployment.
# -----------------------------------------------------------------------------

# --- General ---
project_name = "04-serverless-api"
aws_region   = "eu-west-2"
environment  = "staging"

# --- API Gateway ---
api_stage_name  = "staging"
api_description = "Serverless REST API with Lambda + DynamoDB"

# --- Lambda ---
lambda_runtime     = "python3.12"
lambda_memory_size = 256
lambda_timeout     = 10
