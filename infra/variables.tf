variable "aws_region" {
  description = "AWSリージョン"
  default     = "ap-northeast-1"
}

variable "bucket_name" {
  description = "Name of S3 bucket"
  default     = "marcy-dev-rag-document"
}

variable "lambda_function_name" {
  description = "Lambda関数の名前"
  default     = "my_lambda_function"
}

variable "openai_api_key" {
  description = "OpenAI APIキー"
  type        = string
  sensitive   = true
}

variable "stage_name" {
  description = "Name of the API Gateway stage"
  type        = string
}

variable "aurora_master_username" {
  description = "Aurora PostgreSQLクラスターのマスターユーザー名"
  type        = string
}

variable "aurora_database_name" {
  description = "Aurora PostgreSQLデータベース名"
  type        = string
}
