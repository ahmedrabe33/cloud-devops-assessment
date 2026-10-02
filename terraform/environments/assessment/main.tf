module "network" {
  source = "../../modules/network"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}
module "ecr" {
  source = "../../modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}
module "rds" {
  source = "../../modules/rds"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}
module "ecs" {
  source = "../../modules/ecs"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
  ecr_repository_url = module.ecr.repository_url

  db_endpoint          = module.rds.db_endpoint
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
  db_security_group_id = module.rds.db_security_group_id
}

module "frontend" {
  source = "../../modules/frontend"

  project_name = var.project_name
  environment  = var.environment

  alb_dns_name         = module.ecs.alb_dns_name
  frontend_source_path = "${path.root}/../../../frontend"
}

module "monitoring" {
  source = "../../modules/monitoring"

  project_name     = var.project_name
  environment      = var.environment
  ecs_cluster_name = module.ecs.ecs_cluster_name
  ecs_service_name = module.ecs.ecs_service_name
}
module "cicd" {
  source = "../../modules/cicd"

  project_name = var.project_name
  environment  = var.environment

  github_owner = "ahmedrabe33"
  github_repo  = "cloud-devops-assessment"

  ecr_repository_arn     = module.ecr.repository_arn
  ecs_cluster_arn        = module.ecs.ecs_cluster_arn
  ecs_service_arn        = module.ecs.ecs_service_arn
  ecs_execution_role_arn = module.ecs.ecs_execution_role_arn
}
