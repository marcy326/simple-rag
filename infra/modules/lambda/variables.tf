variable "zip_file" {
  description = "Path to the Lambda ZIP file"
  type        = string
}

variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "lambda_role_arn" {
  description = "IAM Role ARN for Lambda"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables for Lambda"
  type        = map(string)
  default     = {}
}

variable "timeout" {
  default = 60
}