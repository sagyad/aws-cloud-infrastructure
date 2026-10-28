
# Project 01: High-Availability Multi-AZ Architecture

Production-ready multi-AZ infrastructure with auto-scaling, managed database, and Redis caching layer — deployed via GitHub Actions CI/CD.

---

## 🏗️ Architecture Overview

 Internet
                   │
                [ ALB ]
               /       \
          [EC2 AZ-a]  [EC2 AZ-b]     ← Auto Scaling Group (2-4 instances)
               \       /
             [ Security ]
               /       \
      [RDS Primary]  [RDS Standby]    ← Multi-AZ (automatic failover)
                   │
               [ Redis ]              ← ElastiCache Replication Group

---

## 🛠️ Infrastructure Components

| Component | Service | Purpose |
|-----------|---------|---------|
| Networking | VPC, Subnets, IGW, NAT, Route Tables | Multi-AZ network isolation |
| Load Balancer | Application Load Balancer | Distributes traffic across AZs |
| Compute | Auto Scaling Group + Launch Template | Self-healing EC2 instances (2-4) |
| Database | RDS MySQL Multi-AZ | Automatic failover, encrypted storage |
| Cache | ElastiCache Redis | In-memory caching for performance |
| Security | Security Groups | Least-privilege network access |

---

## 📁 Project Structure

```
01-high-availability-multi-az/
├── terraform/
│   ├── modules/
│   │   ├── vpc/          # VPC, Subnets, IGW, NAT, Route Tables
│   │   ├── compute/      # ALB, ASG, Launch Template, Security Groups
│   │   ├── database/     # RDS MySQL Multi-AZ, Subnet Group
│   │   └── cache/        # ElastiCache Redis Replication Group
│   ├── environments/
│   │   ├── dev.tfvars    # Development environment config
│   │   ├── staging.tfvars # Staging environment config
│   │   └── prod.tfvars   # Production environment config
│   ├── provider.tf       # AWS provider + S3 backend
│   ├── variables.tf      # Input variable declarations
│   ├── locals.tf         # Calculated values + common tags
│   ├── main.tf           # Root module — connects all modules
│   └── outputs.tf        # ALB DNS, DB endpoint, Redis endpoint
└── docs/
    └── architecture.md   # Architecture decisions documentation
```



---

## 🔑 Key Design Decisions

- **Multi-AZ deployment** — ALB, ASG, and RDS span 2 availability zones for fault tolerance
- **Private subnets for data layer** — RDS and Redis are not internet-accessible
- **Auto Scaling Group** — self-healing with min 2, max 4 EC2 instances
- **RDS Multi-AZ** — automatic failover with zero manual intervention
- **Modular Terraform** — each component is a reusable module

---

## 🚀 Deployment

```bash
# Navigate to terraform directory
cd terraform

# Initialise
terraform init

# Plan with environment config
terraform plan -var-file=environments/dev.tfvars -out=tfplan

# Apply saved plan
terraform apply "tfplan"
```

## CI/CD Pipeline
GitHub Actions workflow: .github/workflows/01-high-availability.yml

| Trigger | Action |
|---------|--------|
| Pull Request | Terraform Plan (review changes) |
| Merge to Main | Terraform Plan + Apply (deploy) |


## Outputs
| Output | Description |
|--------|-------------|
| `eks_cluster_endpoint` | EKS cluster API server URL |
| `eks_cluster_name` | EKS cluster name for kubectl config |
| `eks_node_name` | Managed node group name |
