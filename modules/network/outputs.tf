# VPCのIDを出力
output "vpc_id" {
  description = "作成されたVPCのID"
  value       = aws_vpc.rds_vpc.id
}

# サブネットのIDを出力
output "subnet_ids" {
  description = "作成されたサブネットのID"
  value = [
    aws_subnet.rds_subnet_1.id,
    aws_subnet.rds_subnet_2.id
  ]
}

# セキュリティグループのIDを出力
output "security_group_id" {
  description = "作成されたセキュリティグループのID"
  value       = aws_security_group.aurora.id
}


