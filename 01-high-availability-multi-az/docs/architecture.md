# High-Availability Multi-AZ Architecture

## Overview

Production-grade AWS infrastructure designed to survive an Availability Zone failure with zero downtime. All stateful and stateless components are deployed across two AZs with automated failover.

## Architecture Diagram
                        Internet
                           │
                     ┌─────▼─────┐
                     │  Route 53  │
                     │   (DNS)    │
                     └─────┬─────┘
                           │
                ┌──────────▼──────────┐
                │         ALB          │
                │  (Application Load   │
                │   Balancer)          │
                │  Public Subnets      │
                └────┬───────────┬────┘
                     │           │
          ┌──────────▼──┐  ┌────▼──────────┐
          │    AZ-a      │  │     AZ-b       │
          │              │  │                │
          │  ┌────────┐  │  │  ┌────────┐   │
          │  │  EC2   │  │  │  │  EC2   │   │
          │  │ (ASG)  │  │  │  │ (ASG)  │   │
          │  └───┬────┘  │  │  └───┬────┘   │
          │      │       │  │      │        │
          │  Private     │  │  Private      │
          │  Subnet      │  │  Subnet       │
          │              │  │                │
          │  ┌────────┐  │  │  ┌────────┐   │
          │  │  RDS   │  │  │  │  RDS   │   │
          │  │Primary │  │  │  │Standby │   │
          │  └───┬────┘  │  │  └────────┘   │
          │      │       │  │                │
          │  ┌───▼────┐  │  │  ┌────────┐   │
          │  │ Redis  │  │  │  │ Redis  │   │
          │  │Primary │  │  │  │Replica │   │
          │  └────────┘  │  │  └────────┘   │
          └──────────────┘  └───────────────┘

## Components

### Network Layer
- **VPC** — Isolated network (10.0.0.0/16)
- **Public Subnets (x2)** — ALB lives here, internet-facing
- **Private Subnets (x2)** — EC2, RDS, Redis live here, no direct internet access
- **NAT Gateway** — Allows private subnets to reach internet (for updates)
- **Internet Gateway** — Allows public subnets to receive traffic

### Compute Layer
- **Application Load Balancer (ALB)** — Distributes traffic across EC2 instances in both AZs
- **Auto Scaling Group (ASG)** — Maintains desired EC2 count, replaces unhealthy instances, scales based on CPU
- **Launch Template** — Defines EC2 configuration (AMI, instance type, user data)

### Database Layer
- **RDS PostgreSQL (Multi-AZ)** — Primary in AZ-a, synchronous standby in AZ-b
- **Automated failover** — If primary fails, standby promotes automatically (~60 seconds)

### Caching Layer
- **ElastiCache Redis (Multi-AZ)** — Primary node in AZ-a, read replica in AZ-b
- **Automatic failover** — If primary fails, replica promotes automatically

## Failure Scenarios

| What Fails | What Happens | Downtime |
|------------|-------------|----------|
| Single EC2 instance | ASG replaces it, ALB routes to healthy instances | Zero |
| All EC2 in one AZ | ALB routes to other AZ, ASG launches replacements | Zero |
| RDS Primary | Auto-failover to standby in other AZ | ~60 seconds |
| Redis Primary | Auto-failover to replica in other AZ | ~30 seconds |
| Entire AZ goes down | All components failover to surviving AZ | ~60 seconds |

## Security

- EC2 instances in private subnets (no public IP)
- ALB is the only public-facing component
- Security group chaining: Internet → ALB SG → EC2 SG → RDS SG → Redis SG
- RDS and Redis not accessible from internet

## Cost Estimate (Dev Environment)

| Resource | Estimated Monthly Cost |
|----------|----------------------|
| ALB | ~$16 |
| EC2 (2x t3.micro) | ~$15 |
| RDS (db.t3.micro Multi-AZ) | ~$25 |
| ElastiCache (cache.t3.micro) | ~$12 |
| NAT Gateway | ~$32 |
| **Total** | **~$100/month** |

> **Note:** Destroy after testing to avoid costs. Dev environment uses smallest instance sizes.

