output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

output "nat_gateway_id" {
  value = module.network.nat_gateway_id
}
output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "ecr_repository_name" {
  value = module.ecr.repository_name
}
output "db_endpoint" {
  value = module.rds.db_endpoint
}

output "db_port" {
  value = module.rds.db_port
}

output "db_security_group_id" {
  value = module.rds.db_security_group_id
}
output "alb_dns_name" {
  value = module.ecs.alb_dns_name
}

output "ecs_cluster_name" {
  value = module.ecs.ecs_cluster_name
}

output "ecs_service_name" {
  value = module.ecs.ecs_service_name
}
output "frontend_bucket_name" {
  value = module.frontend.frontend_bucket_name
}

output "ecs_cpu_alarm_name" {
  value = module.monitoring.ecs_cpu_alarm_name
}
output "github_actions_role_arn" {
  value = module.cicd.github_actions_role_arn
}
output "frontend_website_url" {
  value = module.frontend.website_url
}
