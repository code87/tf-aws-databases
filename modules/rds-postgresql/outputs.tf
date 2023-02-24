output "db_endpoint" {
  value = aws_db_instance.database.endpoint
}

output "db_instance_class" {
  value = aws_db_instance.database.instance_class
}

output "postgresql_sg_id" {
  value = aws_security_group.postgresql_sg.id
}
