# -----------------------------------------------------------------------------
# Node Module — Input Variables
# Only values the module needs FROM OUTSIDE to build the network.
# -----------------------------------------------------------------------------

variable "name_prefix" {
  type        = string
  description = "Naming prefix for all resources (e.g. eks-cluster-az-dev)"
}

variable "cluster_name" {
  type        = string
  description = "EKS Cluster Name"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for EKS cluster"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for worker nodes"
}

variable "desired_capacity" {
  type        = number
  description = "Desired number of worker nodes"
}

variable "min_capacity" {
  type        = number
  description = "Minimum number of worker nodes"
}

variable "max_capacity" {
  type        = number
  description = "Maximum number of worker nodes"
}


variable "common_tags" {
  type        = map(string)
  description = "Common tags to apply to all resources"
}