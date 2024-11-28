resource "aws_vpc" "rds_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "RDS VPC"
  }
}

resource "aws_subnet" "rds_subnet_1" {
  vpc_id     = aws_vpc.rds_vpc.id
  cidr_block = var.subnet_cidr
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "RDS Subnet 1"
  }
}

resource "aws_subnet" "rds_subnet_2" {
  vpc_id     = aws_vpc.rds_vpc.id
  cidr_block = "10.20.2.0/24"  # 別のサブネットCIDRブロック
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "RDS Subnet 2"
  }
}

resource "aws_security_group" "aurora" {
  name        = "aurora-security-group"
  description = "Security group for Aurora PostgreSQL cluster"
  vpc_id      = aws_vpc.rds_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Aurora PostgreSQL Security Group"
  }
}