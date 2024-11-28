variable "AWS_REGION" {
  description = "AWSリージョン"
  default     = "ap-northeast-1"
}

variable "BUCKET_NAME" {
  description = "Name of S3 bucket"
  default     = "marcy-dev-rag-document"
}

variable "LAMBDA_FUNCTION_NAME" {
  description = "Lambda関数の名前"
  default     = "my_lambda_function"
}

variable "OPENAI_API_KEY" {
  description = "OpenAI APIキー"
  type        = string
  sensitive   = true
}

variable "STAGE_NAME" {
  description = "Name of the API Gateway stage"
  type        = string
}

variable "AURORA_MASTER_USERNAME" {
  description = "Aurora PostgreSQLクラスターのマスターユーザー名"
  type        = string
}

variable "AURORA_DATABASE_NAME" {
  description = "Aurora PostgreSQLデータベース名"
  type        = string
}

variable "AURORA_MASTER_PASSWORD" {
  description = "Aurora PostgreSQLクラスターのマスターパスワード"
  type        = string
  sensitive   = true
}
