resource "aws_lambda_function" "lambda_function" {
  filename         = data.archive_file.dummy.output_path
  function_name    = var.function_name
  role             = var.lambda_role_arn
  timeout          = var.timeout
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
  environment {
    variables = var.environment_variables
  }
  lifecycle {
    ignore_changes = all
  }
}

data "archive_file" "dummy" {
  type        = "zip"
  output_path = "${path.module}/tmp/dummy.zip"
  source {
    content  = "# initialized by terraform"
    filename = "lambda_function.py"
  }
  depends_on = [
    null_resource.null
  ]
}

resource "null_resource" "null" {}