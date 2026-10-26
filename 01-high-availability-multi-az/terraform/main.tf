# -----------------------------------------------------------------------------
# Root Module
# Wires all modules together — passes variables and module outputs between
# VPC, Compute, Database, and Cache to build the HA Multi-AZ infrastructure.
# -----------------------------------------------------------------------------

# --- VPC Module ---
module "vpc" {
  source      = "./modules/vpc"
  cidr        = var.vpc_cidr
  azs         = var.azs
  name_prefix = local.name_prefix
  common_tags = local.common_tags
}

module "compute" {
  source             = "./modules/compute"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  instance_type    = var.instance_type
  min_capacity     = var.min_capacity
  max_capacity     = var.max_capacity
  desired_capacity = var.desired_capacity

  name_prefix = local.name_prefix
  common_tags = local.common_tags
}

module "database" {
  source             = "./modules/database"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  ec2_security_group_id = module.compute.ec2_security_group

  db_instance_class = var.db_instance_class
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password

  name_prefix = local.name_prefix
  common_tags = local.common_tags
}

module "cache" {
  source             = "./modules/cache"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  ec2_security_group_id = module.compute.ec2_security_group

  redis_node_type = var.redis_node_type

  name_prefix = local.name_prefix
  common_tags = local.common_tags
}