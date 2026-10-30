# -----------------------------------------------------------------------------
# Root Module — Outputs
# Exposes API Gateway endpoint and DynamoDB table name
# -----------------------------------------------------------------------------

output "api_endpoint" {
  description = "API Gateway endpoint URL"
  value       = aws_apigatewayv2_stage.main.invoke_url
}

output "dynamodb_table" {
  description = "DynamoDB table name"
  value       = aws_dynamodb_table.main.name
}

output "lambda_function" {
  description = "Lambda function name"
  value       = aws_lambda_function.main.function_name
}
