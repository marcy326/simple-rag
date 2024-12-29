
output "cluster_endpoint" {
  description = "Aurora PostgreSQLクラスターのエンドポイント"
  value       = aws_rds_cluster.cluster.endpoint
}