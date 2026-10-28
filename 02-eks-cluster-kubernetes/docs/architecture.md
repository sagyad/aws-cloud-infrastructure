
# Architecture — EKS Cluster & Managed Kubernetes

## Overview

This project deploys a production-ready Amazon EKS cluster across multiple availability zones with managed node groups, OIDC provider for pod-level IAM access, and Kubernetes manifests for application deployment. The VPC module is sourced from a shared Git registry to promote reusability across projects.

---

## Architecture Decision Records

### ADR-001: EKS Managed Node Group over Self-Managed

**Decision:** Use EKS Managed Node Group instead of self-managed EC2 nodes.

**Reason:** Managed node groups handle AMI updates, patching, and draining automatically. Self-managed nodes require manual lifecycle management which increases operational overhead with no benefit for this use case.

### ADR-002: VPC Module from Git Registry

**Decision:** Source VPC module from shared Git repository instead of duplicating locally.

**Reason:** The VPC module is identical across projects. Sourcing from Git ensures a single source of truth, consistent networking configuration, and version-controlled changes. Updates to the VPC module propagate to all projects referencing it.

### ADR-003: OIDC Provider for Pod-Level IAM

**Decision:** Configure an OIDC identity provider on the EKS cluster.

**Reason:** OIDC enables individual pods to assume specific IAM roles rather than inheriting the node's IAM role. This follows the principle of least privilege — a pod that reads from S3 does not need DynamoDB permissions that another pod requires.

### ADR-004: Kubernetes Service Type LoadBalancer

**Decision:** Use Service type LoadBalancer instead of NodePort or ClusterIP with Ingress.

**Reason:** LoadBalancer is the simplest approach for exposing a single application. AWS automatically provisions an ALB. Ingress controllers (covered in the DevOps repo) are better suited for multi-service routing with path-based rules.

### ADR-005: nginx:alpine as Demo Image

**Decision:** Deploy nginx:alpine from Docker Hub instead of a custom ECR image.

**Reason:** Docker Desktop is not available on the development machine, preventing local image builds. nginx:alpine serves as a lightweight stand-in to validate the full deployment pipeline. The architecture supports ECR images — only the image reference in deployment.yaml changes.

---

## Infrastructure Components

### EKS Module

The EKS module creates the control plane, IAM role with 5 AWS managed policies, and an OIDC provider for pod-level IAM access. The cluster is configured with public endpoint access for kubectl operations and uses the private subnets from the VPC module for worker node placement.

### Nodes Module

The Nodes module creates a managed node group with a dedicated IAM role. The node group spans 2 availability zones with a minimum of 2 and maximum of 4 t3.medium instances. The Auto Scaling Group ensures self-healing — if a node becomes unhealthy, AWS replaces it automatically.

### VPC Module (Git Registry)

The VPC is sourced from a shared Git repository. It provides a /16 CIDR block split into public and private subnets across 2 availability zones. Public subnets host the internet-facing load balancer. Private subnets host the EKS nodes. NAT Gateway enables outbound internet access from private subnets.

---

## Networking Flow

User Request → Internet → LoadBalancer (public subnet) → kube-proxy routes to correct Pod (private subnet) → Pod processes request → response returns same path

Pod → needs AWS access → assumes IAM role via OIDC Pod → needs internet → NAT Gateway (outbound only) Pod → needs another pod → coredns resolves name → aws-node routes traffic


---

## Security

All EKS nodes run in private subnets with no direct internet access. Inbound traffic flows exclusively through the Kubernetes LoadBalancer service. The OIDC provider enables pod-level IAM roles following least-privilege principles. Node IAM roles carry only the 5 AWS managed policies required for EKS operation.

---

## Kubernetes Resources

The application layer consists of a Deployment running 3 nginx replicas and a Service of type LoadBalancer. The Deployment uses a rolling update strategy for zero-downtime deployments. Pods are distributed across nodes by the Kubernetes scheduler. Self-healing is automatic — if a pod is terminated, the Deployment controller creates a replacement within seconds.

---

## Cost Considerations

EKS control plane costs $0.10 per hour ($73/month). Each t3.medium node costs approximately $0.04 per hour. With 2 nodes running, the total infrastructure cost is approximately $130/month. The cluster should be destroyed when not in use for learning purposes. Multi-environment deployment (dev, staging, prod) is supported via tfvars files but only dev is deployed to manage costs.
