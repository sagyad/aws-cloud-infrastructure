# -----------------------------------------------------------------------------
# Output Values — Static Website Infrastructure
# Exposes the S3 bucket name and CloudFront distribution URL for
# website deployment and browser access.
# -----------------------------------------------------------------------------

output "bucket_name" {
  description = "S3 bucket name for uploading website files"
  value       = aws_s3_bucket.main.bucket
}

output "cloudfront" {
  description = "CloudFront distribution URL — open this in your browser"
  value       = aws_cloudfront_distribution.main.domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront Distribution ID for cache invalidation"
  value       = aws_cloudfront_distribution.main.id
}