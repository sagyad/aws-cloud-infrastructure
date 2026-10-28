# -----------------------------------------------------------------------------
# Production Environment Configuration
# Largest instance sizes to minimise cost during development and testing.
# -----------------------------------------------------------------------------

# --- General ---
environment = "dev"
aws_region  = "eu-west-2"

# --- Network ---
cidr_block = "10.3.0.0/16"

# --- Node ---
instance_type    = "t3.medium"
min_capacity     = 2
max_capacity     = 4
desired_capacity = 2