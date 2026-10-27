# -----------------------------------------------------------------------------
# EKS Module — Core Kubernetes Infrastructure
# Creates the EKS cluster, IAM role with required AWS managed policies,
# and OIDC provider for pod-level AWS service access.
# Control plane is fully managed by AWS — no patching or maintenance required.
# -----------------------------------------------------------------------------


# --- IAM Role for EKS Cluster ---
# EKS needs a role to manage AWS resources (networking, compute, storage)
# on your behalf. Trust policy allows only eks.amazonaws.com to assume it.
resource "aws_iam_role" "cluster" {
  name = "${var.name_prefix}-eks-cluster"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
  tags = var.common_tags
}


# --- Attach All 5 AWS Managed Policies (same as Console auto-attaches) ---
resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}


# --- EKS Cluster ---
# The control plane — AWS manages upgrades, patching, and HA.
# Deployed into private subnets for security.
resource "aws_eks_cluster" "main" {
  name     = "${var.name_prefix}-cluster"
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy,
  ]

  tags = var.common_tags
}

# --- OIDC Provider ---
# Allows Kubernetes pods to assume IAM roles securely.
# Without this, pods can't access S3, DynamoDB, etc.

data "tls_certificate" "cluster" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer

  tags = var.common_tags
}

