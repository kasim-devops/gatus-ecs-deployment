variable "domain_name" {
  type    = string
  default = "tm.labs.kas-app.xyz"
}

variable "route53_zone_name" {
  type    = string
  default = "labs.kas-app.xyz"
}

variable "gatus_image" {
  type        = string
  description = "The Docker image URI for Gatus."
}

variable "aws_region" {
  type        = string
  description = "The AWS region for CloudWatch log and log configuration."
  default     = "eu-west-2"
}