resource "aws_rds_cluster" "cluster" {
  cluster_identifier                  = "aurora-pg-cluster"
  engine                              = "aurora-postgresql"
  engine_version                      = "16.3"
  engine_mode                         = "provisioned"
  manage_master_user_password         = true
  master_username                     = var.aurora_master_username
  port                                = 5432
  database_name                       = var.aurora_database_name
  vpc_security_group_ids              = [var.security_group_id]
  db_subnet_group_name                = aws_db_subnet_group.subnets.name
  iam_database_authentication_enabled = true
  enable_http_endpoint                = true
  skip_final_snapshot                 = true
  serverlessv2_scaling_configuration {
    min_capacity = 0
    max_capacity = 1.0
  }
}

resource "aws_rds_cluster_instance" "instance" {
  cluster_identifier        = aws_rds_cluster.cluster.id
  identifier                = "${aws_rds_cluster.cluster.cluster_identifier}-serverless-instance"
  engine                    = aws_rds_cluster.cluster.engine
  engine_version            = aws_rds_cluster.cluster.engine_version
  instance_class            = "db.serverless"
  db_subnet_group_name      = aws_db_subnet_group.subnets.name
}

resource "aws_db_subnet_group" "subnets" {
  name       = "aurora-pg-subnet-group"
  subnet_ids = var.subnet_ids
}
