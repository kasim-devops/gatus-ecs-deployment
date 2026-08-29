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