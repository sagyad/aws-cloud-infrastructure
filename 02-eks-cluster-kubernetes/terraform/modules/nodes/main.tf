# -----------------------------------------------------------------------------
# EKS Nodes — EC2 Infrastructure
# Creates the EKS Nodes, IAM role with required AWS managed policies,
# and OIDC provider for pod-level AWS service access.
# Control plane is fully managed by AWS — no patching or maintenance required.
# -----------------------------------------------------------------------------

resource "aws_iam_role" "main" {
  name = "${var.name_prefix}-nodes"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}


resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_pull_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
  role       = aws_iam_role.main.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.main.name
}
resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_minimal_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodeMinimalPolicy"
  role       = aws_iam_role.main.name
}

resource "aws_iam_role_policy_attachment" "amazon_elastic_container_registry_public_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicReadOnly"
  role       = aws_iam_role.main.name
}

resource "aws_eks_node_group" "main" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.name_prefix}-node"
  instance_types  = [var.instance_type]
  node_role_arn   = aws_iam_role.main.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_capacity
    min_size     = var.min_capacity
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_pull_only,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_eks_worker_node_minimal_policy,
    aws_iam_role_policy_attachment.amazon_elastic_container_registry_public_read_only
  ]
}