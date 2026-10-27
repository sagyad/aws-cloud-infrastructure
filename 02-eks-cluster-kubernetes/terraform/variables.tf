# -----------------------------------------------------------------------------
# Input Variables
# Defines all configurable parameters for the HA Multi-AZ infrastructure.
# Values are set per environment in environments/*.tfvars files.
# -----------------------------------------------------------------------------

# --- General ---
variable "environment" {
  type        = string
  description = "Deployment environment (dev, staging, prod)"
}
variable "aws_region" {
  type        = string
  description = "AWS region for all resources"
}

# --- Network ---
variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC (e.g. 10.0.0.0/16)"
}
# --- Node ---
variable "instance_type" {
  type        = string
  description = "EC2 instance type for the Auto Scaling Group"
}

variable "min_capacity" {
  type        = number
  description = "Minimum number of EC2 instances in the Auto Scaling Group"
}

variable "max_capacity" {
  type        = number
  description = "Maximum number of EC2 instances in the Auto Scaling Group"
}

variable "desired_capacity" {
  type        = number
  description = "Desired number of EC2 instances in the Auto Scaling Group"
}
