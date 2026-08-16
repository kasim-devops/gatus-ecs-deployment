variable "availability_zone_names" {
  type        = list(string)
  description = "List of availability zones where resources will be deployed."
  default     = ["eu-west-2a", "eu-west-2b"]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR block for the public subnet."
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR block for the private subnet."
  default     = ["10.0.5.0/24", "10.0.6.0/24"]
}