# -----------------------------------------------------------------------------
# Root Outputs
# Exposes key endpoints for application access and configuration.
# ALB DNS for web traffic, RDS endpoint for database, Redis for caching.
# -----------------------------------------------------------------------------


output "alb_dns_name" {
  description = "Application Loadbalancer DNS Name"
  value       = module.compute.alb_dns_name
}

output "db_endpoint" {
  description = "RDS endpoint"
  value       = module.database.db_endpoint
}

output "redis_endpoint" {
  description = "Redis endpoint"
  value       = module.cache.redis_endpoint
}