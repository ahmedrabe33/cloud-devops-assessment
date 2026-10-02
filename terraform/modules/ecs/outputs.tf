output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  value = aws_ecs_service.backend.name
}

output "ecs_security_group_id" {
  value = aws_security_group.ecs.id
}
output "ecs_cluster_arn" {
  value = aws_ecs_cluster.main.arn
}

output "ecs_service_arn" {
  value = aws_ecs_service.backend.arn
}
output "ecs_execution_role_arn" {
  value = aws_iam_role.execution.arn
}
