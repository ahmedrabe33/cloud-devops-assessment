variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "cloud-devops-assessment"
}

variable "environment" {
  type    = string
  default = "assessment"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type = list(string)

  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "private_subnet_cidrs" {
  type = list(string)

  default = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]
}

variable "availability_zones" {
  type = list(string)

  default = [
    "us-east-1a",
    "us-east-1b"
  ]
}
variable "db_name" {
  type    = string
  default = "devopsdb"
}

variable "db_username" {
  type    = string
  default = "devops"
}

variable "db_password" {
  type      = string
  sensitive = true
}
