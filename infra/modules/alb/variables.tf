variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for the ALB."
}

variable "alb_security_group_id" {
  type        = string
  description = "The security group ID for the ALB."
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID where the ALB will be deployed."
}

variable "certificate_arn" {
  type        = string
  description = "The ARN of the ACM certificate for HTTPS."
}

variable "route53_zone_name" {
  type        = string
  description = "The name of the Route 53 hosted zone."
}

variable "app_domain_name" {
  type        = string
  description = "The Full domain name the ALB should be reachable at."
}