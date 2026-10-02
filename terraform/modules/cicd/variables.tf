variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "github_owner" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "ecr_repository_arn" {
  type = string
}

variable "ecs_cluster_arn" {
  type = string
}

variable "ecs_service_arn" {
  type = string
}
variable "ecs_execution_role_arn" {
  type = string
}
