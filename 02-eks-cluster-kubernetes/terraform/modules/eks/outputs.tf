# -----------------------------------------------------------------------------
# EKS Module — Outputs
# Exposes cluster details required by the Nodes module and root main.tf.
# cluster_name and endpoint are needed for node group registration.
# OIDC ARN is needed for pod-level IAM role access.
# -----------------------------------------------------------------------------


output "cluster_name" {
  description = "EKS Cluster Name"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "EKS Cluster API Endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_ca_certificate" {
  description = "EKS Cluster CA Certificate for authentication"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "oidc_provider_arn" {
  description = "OIDC Provider ARN for pod IAM role access"
  value       = aws_iam_openid_connect_provider.cluster.arn
}