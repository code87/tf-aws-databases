data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_secretsmanager_secret_version" "credentials" {
  secret_id = var.db_credentials_secret
}

data "aws_kms_key" "kms_key" {
  key_id = "alias/${var.kms_key}"
}
