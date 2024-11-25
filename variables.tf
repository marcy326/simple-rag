variable "aws_region" {
  description = "AWSリージョン"
  default     = "ap-northeast-1"
}

variable "lambda_function_name" {
  description = "Lambda関数の名前"
  default     = "my_lambda_function"
}

variable "openai_api_key" {
  description = "OpenAI APIキー"
  type        = string
}

variable "db_user" {
  description = "データベースのユーザー名"
  type        = string
}

variable "db_password" {
  description = "データベースのパスワード"
  type        = string
}

variable "db_name" {
  description = "データベース名"
  type        = string
}

variable "stage_name" {
  description = "Name of the API Gateway stage"
  type        = string
}
