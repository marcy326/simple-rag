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