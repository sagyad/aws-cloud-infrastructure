# Project 03 — Static Website + CloudFront

Production-ready static website hosting on AWS using S3, CloudFront CDN.

## 🏗️ Architecture

```
Internet 
    | 
[ CloudFront CDN ] ── Edge locations (global caching) 
    │ 
[ OAC ] ── Origin Access Control (only CloudFront can access S3) 
    │ 
[ S3 Bucket ] ── Static files (HTML, CSS, JS)
```

## 📋 Infrastructure Components

| Resource | Purpose |
|----------|---------|
| S3 Bucket | Store website files (private, not public) |
| CloudFront Distribution | CDN — serve from 400+ edge locations |
| Origin Access Control (OAC) | Security — only CloudFront reads S3 |
| S3 Bucket Policy | Allow CloudFront via OAC |

## 📁 Project Structure

```
03-static-website-cloudfront/ 
├── terraform/ 
│ ├── environments/ 
│ │ └── dev.tfvars # Environment-specific values 
│ ├── provider.tf # AWS provider + S3 backend 
│ ├── variables.tf # Input variable declarations 
│ ├── locals.tf # Calculated values + common tags 
│ ├── main.tf # S3, CloudFront, OAC 
│ └── outputs.tf # CloudFront URL, S3 bucket name 
├── website/ 
│ └── index.html # Sample static website 
├── docs/ 
│ └── architecture.md # Architecture decisions 
└── README.md # This file
```

## 🔧 Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| S3 Private + OAC | S3 bucket is not publicly accessible — CloudFront is the only entry point |
| CloudFront CDN | Content cached at edge locations globally — low latency |
| No modules | Resources are tightly coupled — flat structure is simpler |

## 🚀 Deployment

```bash
cd terraform
terraform init
terraform plan -var-file=environments/dev.tfvars -out=tfplan
terraform apply "tfplan"
```

## 📤 Outputs
| Output | Description |
|--------|-------------|
| s3_bucket_name |	S3 bucket storing website files |
| cloudfront_domain | CloudFront distribution URL |

## 🔄 CI/CD
| Trigger | Action |
|---------|--------|
| Pull Request| Terraform Plan (review changes) |
| Merge to Main| Terraform Apply (deploy infrastructure) |