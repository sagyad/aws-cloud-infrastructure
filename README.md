
# AWS Cloud Infrastructure — Production-Ready Projects

Real-world AWS infrastructure projects built with **Terraform**, deployed via **GitHub Actions CI/CD**, following industry best practices for high availability, security, and scalability.

> **Author:** Sagar Yadav | Cloud & DevOps Engineer
>
> **Modules Registry:** Reusable Terraform modules managed via [Spacelift](https://spacelift.io)

---

## 🏗️ Projects

| # | Project | Key Services | Status |
|---|---------|-------------|--------|
| 01 | [High-Availability Multi-AZ](./01-high-availability-multi-az) | VPC, ALB, ASG, RDS Multi-AZ, ElastiCache Redis | ✅ Complete |
| 02 | [EKS Cluster & Kubernetes](./02-eks-cluster-kubernetes) | EKS, Managed Node Groups, OIDC, kubectl | ✅ Complete |
| 03 | Static Website (S3 + CloudFront + Route53) | S3, CloudFront, ACM, Route53 | 🔜 In Progress |
| 04 | Serverless API (Lambda + API Gateway + DynamoDB) | Lambda, API Gateway, DynamoDB | 🔜 Planned |
| 05 | Infrastructure Monitoring (CloudWatch) | CloudWatch, SNS, Alarms, Dashboards | 🔜 Planned |
| 06 | Multi-Account Landing Zone (AWS Orgs) | Organizations, SCPs, SSO, Control Tower | 🔜 Planned |
| 07 | Security & Compliance (IAM + GuardDuty) | IAM, GuardDuty, Config, WAF, NACL | 🔜 Planned |
| 08 | Disaster Recovery (Cross-Region) | Cross-region replication, Route53 failover | 🔜 Planned |

---

## 🛠️ Tech Stack

| Category | Tools |
|----------|-------|
| **IaC** | Terraform (v1.17+) |
| **CI/CD** | GitHub Actions |
| **Cloud** | AWS (eu-west-2) |
| **Module Registry** | Spacelift |
| **State Management** | S3 + DynamoDB |
| **Environments** | Dev, Staging, Production (via tfvars) |

---

## 📁 Repository Structure
```
aws-cloud-infrastructure/ 
├── .github/workflows/ # CI/CD pipelines (one per project) 
│ ├── 01-high-availability.yml 
│ └── 02-eks-cluster.yml 
├── 01-high-availability-multi-az/ 
│ ├── terraform/ # Infrastructure code 
│ │ ├── modules/ # VPC, Compute, Database, Cache 
│ │ ├── environments/ # dev.tfvars, staging, prod 
│ │ └── *.tf # Root module 
│ └── docs/ # Architecture documentation 
├── 02-eks-cluster-kubernetes/ 
│ ├── terraform/ # EKS infrastructure 
│ │ ├── modules/ # EKS, Nodes 
│ │ └── environments/ # dev.tfvars 
│ ├── k8s/ # Kubernetes manifests 
│ │ ├── deployment.yaml 
│ │ └── service.yaml 
│ ├── app/ # Sample application 
│ └── docs/ # Architecture documentation 
└── README.md
```

---

## 🔁 CI/CD Pipeline Pattern

Every project follows the same deployment pattern:

Pull Request → Terraform Plan (validate + review) Merge to Main → Terraform Apply (deploy to AWS)


- **Plan** runs on every PR — review infrastructure changes before merging
- **Apply** runs only after merge to `main` — ensures only approved changes are deployed
- Environment-specific deployments via `tfvars` files

---

## 📦 Reusable Modules (Spacelift Registry)

| Module | Version | Description |
|--------|---------|-------------|
| VPC | v0.1.0 | Multi-AZ VPC with public/private subnets, NAT Gateway |
| Compute | v0.1.0 | ALB + Auto Scaling Group with launch template |
| Database | v0.1.0 | RDS Multi-AZ with subnet group and security group |
| Cache | v0.1.0 | ElastiCache Redis replication group |

---
## 🔧 Key Design Decisions

- **Modular Architecture** — Reusable Terraform modules via Git registry (Spacelift)
- **Multi-Environment** — dev, staging, prod using separate tfvars files
- **Remote State** — S3 backend with DynamoDB locking
- **CI/CD** — GitHub Actions with plan-on-PR, apply-on-merge pattern
- **Tagging** — Consistent resource tagging via `locals.tf` common_tags

## 🔐 Security

- IAM roles with least privilege
- Security groups per tier (ALB, App, Database, Cache)
- Private subnets for application and data layers
- No secrets in code — passed via environment variables or GitHub Secrets

## 🚀 Getting Started

### Prerequisites
- Terraform >= 1.17.0
- AWS CLI configured
- GitHub account with repository secrets set

```bash
# Clone the repository
git clone https://github.com/sagyad/aws-cloud-infrastructure.git

# Navigate to a project
cd 01-high-availability-multi-az/terraform

# Initialise Terraform
terraform init

# Plan with environment config
terraform plan -var-file=environments/dev.tfvars

# Apply
terraform apply -var-file=environments/dev.tfvars

📜 License
This project is for educational and portfolio purposes.
