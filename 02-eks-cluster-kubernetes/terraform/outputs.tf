# -----------------------------------------------------------------------------
# Root Module — Outputs
# Exposes key infrastructure values after terraform apply.
# Used for kubectl configuration, monitoring, and CI/CD pipeline integration.
# VPC, cluster, and node group details are surfaced from child modules.
# -----------------------------------------------------------------------------



output "vpc_id" {
  description = "VPC ID for the EKS environment"
  value       = module.vpc.vpc_id
}

output "eks_cluster_name" {
  description = "EKS Cluster name for kubectl configuration"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS API endpoint for kubectl and CI/CD access"
  value       = module.eks.cluster_endpoint
}

output "eks_node_name" {
  description = "Node Group name for monitoring and scaling"
  value       = module.nodes.eks_node_name
}
