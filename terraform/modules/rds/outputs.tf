output "db_endpoint" {
  value = aws_db_instance.postgres.address
}

output "db_port" {
  value = aws_db_instance.postgres.port
}

output "db_security_group_id" {
  value = aws_security_group.rds.id
}

output "db_name" {
  value = var.db_name
}

output "db_username" {
  value = var.db_username
}
