# -----------------------------------------------------------------------------
# Staging Environment Configuration
# Medium instance sizes to minimise cost during development and testing.
# Production values would use larger instances and higher capacity.
# -----------------------------------------------------------------------------

# --- General ---
environment = "dev"
aws_region  = "eu-west-2"

# --- Network ---
cidr_block = "10.2.0.0/16"

# --- Node ---
instance_type    = "t3.medium"
min_capacity     = 2
max_capacity     = 4
desired_capacity = 2
