# -----------------------------------------------------------------------------
# Input Variable Declarations
# Project: 04-serverless-api
#
# Purpose: Declares all input variables consumed by this root module.
#          Values are supplied per-environment via terraform.tfvars files
#          located in the environments/ directory.
#
# Usage:   terraform plan -var-file=environments/dev.tfvars
# -----------------------------------------------------------------------------

variable "project_name" {
  type        = string
  description = "Project identifier used in resource naming"
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev, staging, prod)"
}

variable "aws_region" {
  type        = string
  description = "AWS region for all resources"
}

variable "api_stage_name" {
  type        = string
  description = "API Gateway deployment stage name (e.g. v1)"
}

variable "api_description" {
  type        = string
  description = "Human-readable description for the API Gateway"
}

variable "lambda_runtime" {
  type        = string
  description = "Lambda function runtime (e.g. python3.12)"
}

variable "lambda_memory_size" {
  type        = number
  description = "Memory allocated to Lambda function in MB"
}

variable "lambda_timeout" {
  type        = number
  description = "Lambda function timeout in seconds"
}
