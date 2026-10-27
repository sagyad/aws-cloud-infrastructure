# -----------------------------------------------------------------------------
# Root Module — Infrastructure Orchestration
# Connects all modules to build a production-ready EKS environment.
# VPC is consumed from Spacelift private registry (versioned, reusable).
# EKS and Nodes are local modules — outputs chain between them.
#
# Module chain: VPC (Spacelift) → EKS (local) → Nodes (local)
# Environment-specific values come from environments/*.tfvars files.
# -----------------------------------------------------------------------------

# --- Data Source: Auto-detect availability zones in the region ---
data "aws_availability_zones" "available" {}

module "vpc" {
  source = "git::https://github.com/sagyad/terraform-modules.git//modules/vpc?ref=v1.0.0"

  name_prefix = local.name_prefix
  cidr        = var.cidr_block
  azs         = data.aws_availability_zones.available.names
  common_tags = local.common_tags
}

# EKS — local module
module "eks" {
  source = "./modules/eks"

  name_prefix = local.name_prefix
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnet_ids
  common_tags = local.common_tags
}

# Nodes — local module
module "nodes" {
  source           = "./modules/nodes"
  name_prefix      = local.name_prefix
  subnet_ids       = module.vpc.private_subnet_ids
  cluster_name     = module.eks.cluster_name
  instance_type    = var.instance_type
  desired_capacity = var.desired_capacity
  max_capacity     = var.max_capacity
  min_capacity     = var.min_capacity

  common_tags = local.common_tags
}