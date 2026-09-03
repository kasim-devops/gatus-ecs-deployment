variable "desired_count" {
  type        = number
  description = "The desired number of ECS tasks to run."
  default     = 1
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for the ECS tasks."
}

variable "ecs_security_group_id" {
  type        = string
  description = "The security group ID for the ECS tasks."
}

variable "target_group_arn" {
  type        = string
  description = "The ARN of the target group for the ECS service."
}

variable "cpu" {
  type        = number
  description = "The amount of CPU to allocate to the ECS task."
  default     = 256
}

variable "memory" {
  type        = number
  description = "The amount of memory to allocate to the ECS task."
  default     = 512
}

variable "gatus_image" {
  type        = string
  description = "Full ECR image URI with tag for the Gatus container."
}

variable "aws_region" {
  type        = string
  description = "The AWS region for CloudWatch log and log configuration."
}