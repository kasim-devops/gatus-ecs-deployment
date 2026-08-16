terraform {
  required_version = ">= 1.11"

 backend "s3" {
    bucket       = "gatus-deployment-bucket"
    key          = "gatus-ecs/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = true
    use_lockfile = true
  }
}