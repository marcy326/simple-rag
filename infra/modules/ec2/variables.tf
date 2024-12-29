variable "bucket_name" {
  description = "Name of the existing S3 bucket for init scripts"
  type        = string
}

variable "s3_key" {
  description = "Key of S3 object init scripts"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "aurora_master_username" {
  description = "Aurora PostgreSQL クラスターのマスターユーザー名"
  type        = string
}

variable "aurora_database_name" {
  description = "Aurora PostgreSQL データベース名"
  type        = string
}

variable "aurora_master_password" {
  description = "Aurora PostgreSQL クラスターのマスターパスワード"
  type        = string
  sensitive   = true
}

variable "security_group_id" {
  description = "Aurora PostgreSQLクラスターのセキュリティグループID"
  type        = string
}

variable "subnet_ids" {
  description = "Aurora PostgreSQLクラスターのサブネットID群"
  type        = list(string)
}

variable "cluster_endpoint" {
  description = "Aurora PostgreSQLクラスターのエンドポイント"
  type        = string
}