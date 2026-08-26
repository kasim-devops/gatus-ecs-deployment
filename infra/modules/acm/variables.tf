variable "domain_name" {
  type        = string
  description = "The domain name for the ACM certificate."
}

variable "route53_zone_name" {
  type        = string
  description = "The name of the Route 53 hosted zone for DNS validation."
}