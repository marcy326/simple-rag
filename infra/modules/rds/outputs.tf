output "cluster_arn" {
  value = aws_rds_cluster.cluster.arn
}

output "secret_arn" {
  value = aws_rds_cluster.cluster.master_user_secret[0].secret_arn
}

output "database_name" {
  value = var.aurora_database_name
}