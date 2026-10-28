# Project 02: EKS Cluster & Managed Kubernetes

Production-ready Amazon EKS cluster with managed node groups deployed across multiple availability zones, with OIDC provider for pod-level IAM access.

---

## 🏗️ Architecture Overview

                Internet
                   │
            [ LoadBalancer ]          ← Kubernetes Service (type: LoadBalancer)
                   │
          ┌────────┼────────┐
          │   EKS Cluster   │         ← Control Plane (AWS managed)
          │                 │
     [ Node AZ-a ]   [ Node AZ-b ]   ← Managed Node Group (t3.medium)
     [  Pod  Pod ]   [  Pod  Pod ]    ← 3 replicas spread across nodes
          │                 │
          └────────┼────────┘
                   │
          [ OIDC Provider ]           ← Pod-level AWS access

---

## 🛠️ Infrastructure Components

| Component | Service | Purpose |
|-----------|---------|---------|
| Networking | VPC (reusable Git module) | Multi-AZ with public/private subnets |
| Cluster | EKS | Managed Kubernetes control plane |
| Compute | Managed Node Group | 2-4 t3.medium EC2 instances |
| Identity | OIDC Provider | Pods can assume IAM roles |
| IAM | Cluster + Node Roles | 5 AWS managed policies attached |
| App | Kubernetes Deployment | 3 nginx replicas across nodes |
| Networking | Kubernetes Service | LoadBalancer exposes app to internet |

---

## 📁 Project Structure

```
02-eks-cluster-kubernetes/ ├── terraform/ │ ├── modules/ │ │ ├── eks/ # EKS Cluster, IAM Role, OIDC Provider │ │ └── nodes/ # Node Group, IAM Role, Policy Attachments │ ├── environments/ │ │ └── dev.tfvars # Development environment config │ ├── provider.tf # AWS provider + S3 backend │ ├── variables.tf # Input variable declarations │ ├── locals.tf # Calculated values + common tags │ ├── main.tf # Root module — VPC (Git), EKS, Nodes │ └── outputs.tf # Cluster endpoint, name, certificate ├── k8s/ │ ├── deployment.yaml # 3 replica nginx deployment │ └── service.yaml # LoadBalancer service ├── app/ │ ├── main.py # Flask application (sample) │ ├── requirements.txt # Python dependencies │ └── Dockerfile # Container image definition └── docs/ └── architecture.md # Architecture decisions documentation
```

---

## 🔑 Key Design Decisions

- **Managed Node Group** — AWS handles node updates, patching, and scaling
- **OIDC Provider** — enables pod-level IAM (pods can access S3, DynamoDB etc.)
- **VPC from Git registry** — reusable module, not duplicated per project
- **Multi-AZ nodes** — pods spread across availability zones for fault tolerance
- **Rolling updates** — zero-downtime deployments via Kubernetes strategy

---

## 🚀 Deployment

### Step 1: Infrastructure (Terraform)

```bash
cd terraform
terraform init
terraform plan -var-file=environments/dev.tfvars -out=tfplan
terraform apply "tfplan"
```

### Step 2: Connect kubectl 
aws eks update-kubeconfig --name 02-eks-k8s-dev-cluster --region eu-west-2
kubectl get nodes

### Step 3: Deploy Application
bash

kubectl apply -f ../k8s/deployment.yaml
kubectl apply -f ../k8s/service.yaml
kubectl get services    # Get the LoadBalancer URL

## CI/CD Pipeline

GitHub Actions workflow: `.github/workflows/02-eks-cluster.yml`

| Trigger | Action |
|---------|--------|
| Pull Request | Terraform Plan (review changes) |
| Merge to Main | Terraform Plan + Apply (deploy) |

## Outputs

| Output | Description |
|--------|-------------|
| eks_cluster_endpoint | EKS API server endpoint |
| eks_cluster_name | Cluster name for kubeconfig |
| eks_cluster_certificate | Base64 cluster certificate |
| eks_node_name | Node group name |

## Testing Performed

| Test | Command | Result |
|------|---------|--------|
| Nodes healthy | kubectl get nodes | 2 nodes Ready across 2 AZs |
| Pods running | kubectl get pods -o wide | 3 pods spread across nodes |
| Self-healing | kubectl delete pod | Replaced in 6 seconds |
| Scale up | kubectl scale --replicas=5 | 5 pods running |
| Scale down | kubectl scale --replicas=2 | 2 pods running |
| Rolling update | kubectl set image | Zero-downtime update |
| Rollback | kubectl rollout undo | Reverted to previous version |
| System pods | kubectl get pods -n kube-system | aws-node, coredns, kube-proxy |