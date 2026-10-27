# -----------------------------------------------------------------------------
# Nodes Module — Outputs
# Exposes node group details for root outputs and monitoring.
# -----------------------------------------------------------------------------

output "eks_node_name" {
  description = "EKS Node Group Name"
  value       = aws_eks_node_group.main.node_group_name
}