# -----------------------------------------------------------------------------
# Static Website Infrastructure
# Creates S3 bucket, CloudFront CDN, and OAC for secure static website hosting.
# CloudFront serves content globally; S3 is private, accessible only via OAC.
# -----------------------------------------------------------------------------

# --- 1. S3 Bucket — Stores website files ---
resource "aws_s3_bucket" "main" {
  bucket = "${local.name_prefix}-website"
  force_destroy = true
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-website"
  })
}

# --- 2. OAC — Secure badge for CloudFront to access S3 ---
resource "aws_cloudfront_origin_access_control" "main" {
  name                              = "${local.name_prefix}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# --- 3. CloudFront Distribution — CDN that serves the website ---
resource "aws_cloudfront_distribution" "main" {
  enabled             = true
  default_root_object = "index.html"

  # WHERE to get files
  origin {
    domain_name              = aws_s3_bucket.main.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.main.id
    origin_id                = local.s3_origin_id
  }

  # HOW to serve them
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }
  # WHERE to serve (required — even if no restrictions)
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  # SSL certificate (required — uses CloudFront default)
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-cdn"
  })
}


# --- 4. Bucket Policy — Only CloudFront can read from S3 ---
data "aws_iam_policy_document" "origin_bucket_policy" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.main.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.main.arn]
    }
  }
}

# --- 5. Attach policy to bucket ---
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.main.bucket
  policy = data.aws_iam_policy_document.origin_bucket_policy.json
}



