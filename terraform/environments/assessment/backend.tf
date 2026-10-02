terraform {
  backend "s3" {
    bucket       = "cloud-devops-assessment-771675725500-tfstate"
    key          = "assessment/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
