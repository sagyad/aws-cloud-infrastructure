# -----------------------------------------------------------------------------
# Project 04 — Serverless API
# Root Module — main.tf
#
# Provisions a serverless REST API on AWS using:
#   - IAM Role & Policy    : Execution permissions for Lambda
#   - Lambda Function       : Python handler for API business logic
#   - API Gateway (REST)    : HTTP endpoint exposing Lambda to the internet
#   - DynamoDB Table        : NoSQL database for storing API data
#   - Lambda Permission     : Allows API Gateway to invoke Lambda
#
# Author : Sagar Yadav
# Date   : October 2026
# -----------------------------------------------------------------------------


# --- IAM Role for Lambda ---
resource "aws_iam_role" "lambda" {
  name = "${local.name_prefix}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com" # Only Lambda can wear this badge
      }
    }]
  })

  tags = local.common_tags
}

# --- Role Policy for Lambda  ---
resource "aws_iam_role_policy" "lambda" {
  name = "${local.name_prefix}-lambda-policy"
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*" # Can write logs
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Scan"
        ]
        Resource = aws_dynamodb_table.main.arn # Can read/write DB
      }
    ]
  })
}

# --- Create DynamoDB  ---
resource "aws_dynamodb_table" "main" {
  name         = "${local.name_prefix}-table"
  billing_mode = "PAY_PER_REQUEST" # Serverless pricing
  hash_key     = "id"              # Primary key

  attribute {
    name = "id"
    type = "S"
  }

  tags = local.common_tags
}

# --- Lambda  ---
data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/../app" #  Python code
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "main" {
  filename         = data.archive_file.lambda.output_path
  function_name    = "${local.name_prefix}-function"
  role             = aws_iam_role.lambda.arn
  handler          = "main.handler"
  runtime          = var.lambda_runtime
  memory_size      = var.lambda_memory_size
  timeout          = var.lambda_timeout
  source_code_hash = data.archive_file.lambda.output_base64sha256

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.main.name
    }
  }

  tags = local.common_tags
}


# --- API Gateway ---
resource "aws_apigatewayv2_api" "main" {
  name          = "${local.name_prefix}-api"
  protocol_type = "HTTP"

  tags = local.common_tags
}

# --- Stage (dev/staging/prod) ---
resource "aws_apigatewayv2_stage" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = var.environment
  auto_deploy = true
}

# --- Integration ---
resource "aws_apigatewayv2_integration" "main" {
  api_id                 = aws_apigatewayv2_api.main.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.main.invoke_arn
  payload_format_version = "2.0"
}

# --- Routes (GET) ---
resource "aws_apigatewayv2_route" "get" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /items"
  target    = "integrations/${aws_apigatewayv2_integration.main.id}"
}

# --- Routes (POST) ---
resource "aws_apigatewayv2_route" "post" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "POST /items"
  target    = "integrations/${aws_apigatewayv2_integration.main.id}"
}

# --- Lambda Permission  ---
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}
