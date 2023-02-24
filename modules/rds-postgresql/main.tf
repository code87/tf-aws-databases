terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

locals {
  project_with_stage = "${var.project}-${var.stage}"
  is_prod            = var.stage == "prod"

  db_credentials = jsondecode(
    data.aws_secretsmanager_secret_version.credentials.secret_string
  )
}

resource "aws_security_group" "postgresql_sg" {
  name        = "${local.project_with_stage}-postgresql-sg"
  description = "PostgreSQL access"
  vpc_id      = data.aws_vpc.vpc.id

  tags = {
    Name = "${local.project_with_stage}-postgresql-sg"
  }
}

resource "aws_security_group_rule" "allow_postgresql_inbound" {
  type              = "ingress"
  description       = "Allow inbound traffic to PostgreSQL port"
  security_group_id = aws_security_group.postgresql_sg.id

  from_port   = 5432
  to_port     = 5432
  protocol    = "tcp"
  cidr_blocks = [data.aws_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "allow_all_vpc_outbound" {
  type              = "egress"
  description       = "Allow all outbound traffic inside VPC"
  security_group_id = aws_security_group.postgresql_sg.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = [data.aws_vpc.vpc.cidr_block]
}

resource "aws_db_instance" "database" {
  engine                     = "postgres"
  engine_version             = "13.4"
  instance_class             = var.db_instance_class
  allocated_storage          = var.allocated_storage
  storage_type               = "gp2"
  multi_az                   = false
  identifier                 = "${local.project_with_stage}-db"
  db_name                    = var.db_name
  username                   = local.db_credentials.username
  password                   = local.db_credentials.password
  vpc_security_group_ids     = [aws_security_group.postgresql_sg.id]
  publicly_accessible        = false
  auto_minor_version_upgrade = false
  kms_key_id                 = data.aws_kms_key.kms_key.arn
  storage_encrypted          = true
  deletion_protection        = var.deletion_protection
  skip_final_snapshot        = local.is_prod ? false : true
  final_snapshot_identifier  = "${local.project_with_stage}-db-final-snapshot"
}
