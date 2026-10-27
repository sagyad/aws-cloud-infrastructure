# -----------------------------------------------------------------------------
# EKS Module — Input Variables
# Only values the module needs FROM OUTSIDE to build the network.
# -----------------------------------------------------------------------------

variable "name_prefix" {
  type        = string
  description = "Naming prefix for all resources (e.g. eks-cluster-az-dev)"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where EKS cluster will be deployed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for EKS cluster"
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags to apply to all resources"
}