# s3バケット
data "aws_s3_bucket" "init_scripts" {
  bucket = var.bucket_name
}

# SQLファイルのアップロード
resource "aws_s3_object" "init_sql" {
  bucket = data.aws_s3_bucket.init_scripts.id
  key    = var.s3_key
  source = "${path.module}/init.sql"
  etag   = filemd5("${path.module}/init.sql")
}

# EC2用のIAMロール
resource "aws_iam_role" "ec2_role" {
  name = "db-init-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# S3アクセス用のポリシー
resource "aws_iam_role_policy" "s3_access" {
  name = "s3-access"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          data.aws_s3_bucket.init_scripts.arn,
          "${data.aws_s3_bucket.init_scripts.arn}/*"
        ]
      }
    ]
  })
}

# EC2インスタンスプロファイル
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "db-init-profile"
  role = aws_iam_role.ec2_role.name
}

# セキュリティグループ
resource "aws_security_group" "ec2" {
  name        = "db-init-ec2"
  description = "Security group for DB initialization EC2"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDSセキュリティグループルール
resource "aws_security_group_rule" "rds_from_ec2" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ec2.id
  security_group_id        = var.security_group_id
}

# EC2インスタンス
resource "aws_instance" "db_init" {
  ami           = "ami-0ab02459752898a60" # Amazon Linux 2023
  instance_type = "t3.nano"
  subnet_id     = var.subnet_ids[0]
  
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  security_groups      = [aws_security_group.ec2.id]
  
  user_data = <<-EOF
              #!/bin/bash
              # PostgreSQLクライアントのインストール
              dnf update -y
              dnf install -y postgresql15

              # 初期化スクリプトのダウンロード
              aws s3 cp s3://${data.aws_s3_bucket.init_scripts.id}/${var.s3_key} /tmp/

              # データベース初期化の実行
              PGPASSWORD=${var.aurora_master_password} psql \
                -h ${var.cluster_endpoint} \
                -U ${var.aurora_master_username} \
                -d ${var.aurora_database_name} \
                -f /tmp/init.sql

              # 初期化完了後にインスタンスを終了
              shutdown -h now
              EOF

  tags = {
    Name = "db-initializer"
  }
}