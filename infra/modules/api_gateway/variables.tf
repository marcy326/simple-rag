variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
}

variable "api_description" {
  description = "Description of the API Gateway"
  type        = string
}

variable "resource_path" {
  description = "Path of the resource in the API Gateway"
  type        = string
}

variable "lambda_arn" {
  description = "ARN of the Lambda function"
  type        = string
}

variable "lambda_invoke_arn" {
  description = "ARN of the Lambda function for invoke"
  type        = string
}

variable "stage_name" {
  description = "Name of the API Gateway stage"
  type        = string
}