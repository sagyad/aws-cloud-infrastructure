
# Architecture Decisions — Serverless API

## Overview

Serverless REST API using API Gateway, Lambda, and DynamoDB.
No servers to manage — AWS handles all scaling automatically.

## Architecture Diagram

```
Internet 
    │ 
[ API Gateway ] ── REST API endpoint (front door) 
    │ 
[ Lambda ] ── Python function (runs only when called) 
    │ 
[ DynamoDB ] ── NoSQL database (key-value store)
```

## Key Design Decisions

| Decision | Choice | Reason |
|---|---|---|
| Compute | Lambda | No servers, pay-per-request, auto-scales to zero |
| API Layer | API Gateway | Managed REST API, throttling, CORS built-in |
| Database | DynamoDB | Serverless NoSQL, single-digit ms latency |
| Runtime | Python 3.12 | Lightweight, fast cold start |
| IAM | Least privilege | Lambda role only gets DynamoDB access |

## How It Works

1. User sends HTTP request (GET/POST) to API Gateway
2. API Gateway triggers Lambda function
3. Lambda reads/writes to DynamoDB
4. Response sent back through API Gateway to user

## Cost Model

API Gateway → Pay per request ($3.50 per million) Lambda → Pay per invocation + duration (free tier: 1M requests/month) DynamoDB → Pay per read/write unit (free tier: 25 GB storage)


Zero cost when nobody uses it — that's the power of serverless.