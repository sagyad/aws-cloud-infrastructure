# Architecture — Static Website + CloudFront + Route53

## Overview

This project deploys a production-ready static website on AWS using S3 for storage, CloudFront as CDN, Route53 for DNS, and ACM for SSL certificates.

## Architecture Decisions

### 1. S3 Private Bucket + Origin Access Control (OAC)

S3 bucket is configured as private with all public access blocked. CloudFront accesses S3 through OAC, which is the AWS-recommended replacement for Origin Access Identity (OAI). This ensures no direct access to S3 — all traffic flows through CloudFront.

### 2. CloudFront CDN

CloudFront distributes content from 400+ edge locations worldwide. This reduces latency for end users regardless of their geographic location. Cache behaviour is configured with TTL settings to balance freshness and performance.

### 3. ACM Certificate (SSL/HTTPS)

AWS Certificate Manager provides free SSL certificates. The certificate is created in us-east-1 (required by CloudFront regardless of project region). HTTPS is enforced — HTTP requests are redirected to HTTPS.

### 4. Route53 DNS

Route53 manages DNS with an alias record pointing to the CloudFront distribution. Alias records are free (no per-query charge) and support native AWS resource integration.

### 5. No Module Structure

Unlike Projects 01 and 02, this project uses a flat Terraform structure (no modules). The resources are tightly coupled — CloudFront depends on S3, ACM depends on Route53 validation, and the bucket policy depends on CloudFront OAC. Separating them into modules would add complexity without benefit.

## Security

- S3 bucket: Block all public access enabled
- CloudFront: HTTPS only, TLS 1.2 minimum
- OAC: Signed requests from CloudFront to S3
- Bucket policy: Only allows CloudFront distribution via OAC

## Cost Considerations

- S3: ~$0.023/GB storage + request charges
- CloudFront: Free tier includes 1TB/month transfer
- Route53: $0.50/month per hosted zone
- ACM: Free for public certificates