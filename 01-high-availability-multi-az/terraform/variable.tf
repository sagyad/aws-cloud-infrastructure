# -----------------------------------------------------------------------------
# Input Variables
# Defines all configurable parameters for the HA Multi-AZ infrastructure.
# Values are set per environment in environments/*.tfvars files.
# -----------------------------------------------------------------------------

# --- General ---
variable "project_name" {
  description = "Project name used in resource naming and tags"
  type        = string
}

variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

# --- Network ---
variable "vpc_cidr" {
  description = "CIDR block for the VPC (e.g. 10.0.0.0/16)"
  type        = string
}

variable "azs" {
  description = "Availability Zones for Multi-AZ deployment"
  type        = list(string)
}

# --- Compute (ASG) ---
variable "instance_type" {
  description = "EC2 instance type for the Auto Scaling Group"
  type        = string
}

variable "min_capacity" {
  description = "ASG minimum number of instances"
  type        = number
}

variable "max_capacity" {
  description = "ASG maximum number of instances"
  type        = number
}

variable "desired_capacity" {
  description = "ASG desired number of instances"
  type        = number
}

# --- Database (RDS) ---
variable "db_instance_class" {
  description = "RDS instance class (e.g. db.t3.micro)"
  type        = string
}

variable "db_name" {
  description = "Name of the PostgreSQL database"
  type        = string
}

variable "db_username" {
  description = "Master username for RDS (password via TF_VAR)"
  type        = string
}

variable "db_password" {
  description = "Master password for RDS (passed via TF_VAR — never in tfvars)"
  type        = string
  sensitive   = true
}

# --- Cache (ElastiCache Redis) ---
variable "redis_node_type" {
  description = "ElastiCache Redis node type (e.g. cache.t3.micro)"
  type        = string
}

