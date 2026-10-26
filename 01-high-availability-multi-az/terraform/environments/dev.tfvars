# -----------------------------------------------------------------------------
# Dev Environment Configuration
# Smallest instance sizes to minimise cost during development and testing.
# Production values would use larger instances and higher capacity.
# -----------------------------------------------------------------------------

# --- General ---
project_name = "ha-multi-az"
environment  = "dev"
aws_region   = "eu-west-2"

# --- Network ---
vpc_cidr = "10.0.0.0/16"
azs      = ["eu-west-2a", "eu-west-2b"]

# --- Compute (ASG) ---
instance_type    = "t3.micro"
min_capacity     = 1
max_capacity     = 3
desired_capacity = 2

# --- Database (RDS) ---
db_instance_class = "db.t3.micro"
db_name           = "appdb"
db_username       = "dbadmin"

# --- Cache (ElastiCache Redis) ---
redis_node_type = "cache.t3.micro"
