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