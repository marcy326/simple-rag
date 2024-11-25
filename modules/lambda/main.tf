resource "aws_lambda_function" "lambda_function" {
  filename         = var.zip_file
  function_name    = var.function_name
  role             = var.lambda_role_arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
  timeout          = var.timeout
  source_code_hash = filebase64sha256(var.zip_file)

  environment {
    variables = var.environment_variables
  }
}
