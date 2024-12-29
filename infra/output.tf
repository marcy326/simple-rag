output "cluster_arn" {
  value = module.rds.cluster_arn
}

output "secret_arn" {
  value = module.rds.secret_arn
}

output "database_name" {
  value = module.rds.database_name
}
