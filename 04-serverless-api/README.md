
# Project 04 — Serverless API (Lambda + API Gateway + DynamoDB)

Production-ready serverless REST API on AWS using API Gateway, Lambda, and DynamoDB — fully managed with zero server maintenance.

## 🏗️ Architecture

```
Internet 
    │ 
[ API Gateway ] ── REST API endpoint (HTTPS) 
    │ 
[ Lambda ] ── Python function (auto-scales) 
    │ 
[ DynamoDB ] ── NoSQL database (key-value)
```

## 🧰 Tech Stack

| Component | Service | Purpose |
|---|---|---|
| API Layer | API Gateway | REST endpoint, throttling, CORS |
| Compute | Lambda | Serverless function (Python 3.12) |
| Database | DynamoDB | NoSQL key-value store |
| IAM | Lambda Role | Least privilege DynamoDB access |
| IaC | Terraform | Infrastructure as Code |
| CI/CD | GitHub Actions | Automated deployment |


## 📁 Project Structure

```
04-serverless-api/ 
├── terraform/ 
│ ├── environments/ 
│ │ └── dev.tfvars # Dev environment config 
│ ├── provider.tf # AWS provider + S3 backend 
│ ├── variables.tf # Input variable declarations 
│ ├── locals.tf # Calculated values + common tags 
│ ├── main.tf # API GW, Lambda, DynamoDB, IAM 
│ └── outputs.tf # API URL, Lambda ARN, Table name 
├── website/ 
│ └── lambda_function.py # Lambda handler (developer provides) 
├── docs/ 
│ └── architecture.md # Architecture decisions 
└── README.md # This file
```

## 📊 Outputs

| Output | Description |
|--------|--------|
| api_endpoint   |	API Gateway invoke URL |
| lambda_arn     |	Lambda function ARN |
| dynamodb_table |	DynamoDB table name |

## 🔄 CI/CD Pipeline

| Trigger | Action |
|---------|--------|
| Pull Request  | Terraform Plan (review changes) |
| Merge to Main	| Terraform Apply + Deploy Lambda |

## 🚀 Deployment

### Step 1: Infrastructure (Terraform)

```bash
cd terraform
terraform init
terraform plan -var-file=environments/dev.tfvars
terraform apply -var-file=environments/dev.tfvars

Step 2: Test API

bash
# Create an item
curl -X POST https://<api-url>/items \
  -H "Content-Type: application/json" \
  -d '{"id": "1", "name": "test"}'

# Get all items
curl https://<api-url>/items

📌 Note
This project is for educational and portfolio purposes.