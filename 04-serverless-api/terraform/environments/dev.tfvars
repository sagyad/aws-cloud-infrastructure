# -----------------------------------------------------------------------------
# Dev Environment Configuration
# Project: 04-serverless-api
#
# Purpose: Development environment variable values for the Serverless REST API.
# Usage:   terraform plan -var-file=environments/dev.tfvars
#
# Note: This file is committed to version control as it contains no secrets.
#       Lambda functions run with lower memory and timeout in dev.
# -----------------------------------------------------------------------------

# --- General ---
project_name = "04-serverless-api"
aws_region   = "eu-west-2"
environment  = "dev"

# --- API Gateway ---
api_stage_name  = "dev"
api_description = "Serverless REST API with Lambda + DynamoDB"

# --- Lambda ---
lambda_runtime     = "python3.12"
lambda_memory_size = 256
lambda_timeout     = 10
