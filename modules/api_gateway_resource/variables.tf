variable "rest_api_id" {
  description = "Id of the API Gateway REST API"
  type        = string
}

variable "rest_api_root_resource_id" {
  description = "Id of the API Gateway REST API root resource"
  type        = string
}

variable "rest_api_execution_arn" {
    description = "ARN of the REST API"
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