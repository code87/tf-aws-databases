variable "project" {}

variable "stage" {}

variable "vpc_id" {}

variable "db_instance_class" {
  type    = string
  default = "db.t4g.micro"
}

variable "db_name" {
  description = "Name of the initial database when the RDS instance is created"
  type        = string
}

variable "db_credentials_secret" {
  description = "Name of Secret in AWS Secrets Manager that stores database access details"
  type        = string
}

variable "kms_key" {
  description = "AWS KMS Customer-managed key alias for database encryption"
  type        = string
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled. Default: false"
  type        = bool
  default     = false
}

variable "allocated_storage" {
  description = "The allocated storage in gibabytes. Default: 20"
  type        = number
  default     = 20
}
