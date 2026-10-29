# -----------------------------------------------------------------------------
# Provider Configuration — EKS Cluster & Managed Kubernetes
# Configures AWS provider and Terraform backend for EKS cluster deployment
# with managed node groups and OIDC-based pod identity.
# State stored in S3 with environment-isolated key paths.
# -----------------------------------------------------------------------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "sy-terraform-state-bk-eu-west-2"
    key          = "cloud-infra/02-eks-cluster-kubernetes/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
    encrypt      = true
  }
}